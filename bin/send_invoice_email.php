<?php

/*
 * Copyright (C) 2010 Miller Technology
 * @license GNU General Public License version 2 or later  
 * This scripts generates invoice pdfs of completed and pending contributions & send as email attachment  
 */

// Set the path to save the PDFs
define( 'PDF_FILE_PATH', 'C:/wamp/test/'  );
 
session_start();
require_once '../civicrm.config.php';
require_once 'CRM/Core/Config.php';
$config = CRM_Core_Config::singleton();
CRM_Utils_System::authenticateScript(true);

// load bootstrap to call hooks
require_once 'CRM/Utils/System.php';
CRM_Utils_System::loadBootStrap(  );

$debug = false;

function run($argc, $argv ) {
    global $debug;
    
  ## Initially restricted to this type of contribution only - event fees and member dues
  $contributionTypeID = '2, 4';
  
  ## Send invoice for completed and pending contributions only
  $contributionStatusID = '1, 2';
  
  ## checking count of arguments
  if ($argc > 1) {
    print("One argument will be accepted : pdf_file_delete_flag = true/false");
        exit(-1);
    }

  ## assigning argument value to variable
  if(isset($argv[0]) && ($argv[0] == true || $argv[0] == false)){
    $pdf_delete_flag = $argv[0];
  }
  else{
    ## by default delete flag should set as false
    $pdf_delete_flag = false;
  }
  
  $config =& CRM_Core_Config::singleton();
        
  require_once 'CRM/Utils/Hook.php';
  
  $config->cleanURL = 1;
    
  ## get all pending records from contribution but invoice didnt generated yet

  $query = "SELECT c.id FROM civicrm_contribution c WHERE c.contribution_type_id IN ({$contributionTypeID}) AND c.contribution_status_id IN ({$contributionStatusID}) AND c.id NOT IN (SELECT IFNULL(i.contribution_id,0) FROM civicrm_invoice i)";

  # This query is used for testing - so only picking up the invoice I want
  //$query = "SELECT c.id FROM civicrm_contribution c WHERE c.id = 14";
  
  $dao = CRM_Core_DAO::executeQuery( $query );

  while( $dao->fetch( ) ) {
    $contributionID = $dao->id;
    $pdfContent_obj_contribution_arr = civicrm_invoice_civicrm_pageRun_show_Contribution_Invoice( $contributionID, "external" );
    $pdfContent_obj_arr   = $pdfContent_obj_contribution_arr[0];
    $contributionID   = $pdfContent_obj_contribution_arr[1];
    $pdfContent = $pdfContent_obj_arr[0];
    $obj      = $pdfContent_obj_arr[1];
    
    savePdf($pdfContent, $obj, $contributionID, $pdf_delete_flag);
  }
    
}

function savePdf($pdfContent, $obj, $contributionID, $pdf_delete_flag){
  // getting contribution contact id
  require_once('CRM/Contribute/DAO/Contribution.php');
  $contribution = new CRM_Contribute_DAO_Contribution();
  $contribution->get($contributionID);
  $contactID = $contribution->contact_id;
  
  // Set the path to save the PDFs
  $pdf_path = PDF_FILE_PATH;
  
  ##############################################
  // save pdf file
  $fileName     = "{$obj->invoice_no}.pdf";
  $filePathName   = "{$pdf_path}/{$fileName}";
  
  $handle = fopen($filePathName, 'w');
  file_put_contents($filePathName, $pdfContent);
  fclose($handle);
  
  ## getting from email
  $query = "SELECT v.label FROM civicrm_option_group g, civicrm_option_value v WHERE g.name = 'from_email_address' AND g.id = v.option_group_id AND v.is_default=1";
  $dao = CRM_Core_DAO::executeQuery( $query );
  
  if(!$dao->fetch()){
    print("Not able to get FROM Email Address");
    exit;
  }
  
  $fromEmail = $dao->label;
  
  // send mail
  sendInvoiceMail($obj->email_invoice_address, $obj->attention_of, $fromEmail, $fileName, $filePathName, $obj, $contactID, $contribution);
  
  if($pdf_delete_flag)
  {
    //delete pdf
    @unlink($filePathName);
  }
}

function sendInvoiceMail($email, $displayName, $fromEmail, $fileName, $filePathName, $obj, $contactID, $contribution){

  ## getting contact detail
  require_once 'api/v2/Contact.php';
  $contactParams = array('id' => $contactID);
  $contact =& civicrm_contact_get($contactParams);

  ## Check the contribution type to work out which email template we should be using
  //print_r($contribution); exit;
  $contributionTypeId = $contribution->contribution_type_id;
  
  if($contributionTypeId == '2') {
    ##  Contribution Type - Membership 
    $emailTemplateName = 'Membership Invoice'; 
    $params['bcc']       =  'test@example.com';
  }
  
  if($contributionTypeId == '4') {
    ##  Contribution Type - Events
    $emailTemplateName = 'Participant Invoice';
    $params['bcc']       =  'test@example.com';
  }
  
      
  ## getting invoice mail template
  $query = "SELECT * FROM civicrm_msg_template WHERE msg_title = '{$emailTemplateName}' AND is_active=1";
  $dao = CRM_Core_DAO::executeQuery( $query );
  
  if(!$dao->fetch()){
    print("Not able to get Email Template");
    exit;
  }
  
  $text   = $dao->msg_text;
  $html   = $dao->msg_html;
  $subject  = $dao->msg_subject;  
  
  ###################################################
  require_once("CRM/Mailing/BAO/Mailing.php");
  $mailing = new CRM_Mailing_BAO_Mailing;
  $mailing->body_text = $text;
  $mailing->body_html = $html;
  $tokens = $mailing->getTokens();
  
  require_once("CRM/Utils/Token.php");
  $subject = CRM_Utils_Token::replaceDomainTokens($subject, $domain, true, $tokens['text']);
  $text    = CRM_Utils_Token::replaceDomainTokens($text,    $domain, true, $tokens['text']);
  $html    = CRM_Utils_Token::replaceDomainTokens($html,    $domain, true, $tokens['html']);
  if ($contactID) {
    $subject = CRM_Utils_Token::replaceContactTokens($subject, $contact, false, $tokens['text']);
    $text    = CRM_Utils_Token::replaceContactTokens($text,    $contact, false, $tokens['text']);
    $html    = CRM_Utils_Token::replaceContactTokens($html,    $contact, false, $tokens['html']);
  }
  
  // parse the three elements with Smarty
  require_once 'CRM/Core/Smarty/resources/String.php';
  civicrm_smarty_register_string_resource();
  $smarty =& CRM_Core_Smarty::singleton();
  foreach ($params['tplParams'] as $name => $value) {
    $smarty->assign($name, $value);
  }

  ###################################################
  
  $params['text']       = $text;
  $params['html']       = $html;
  $params['subject']      = $subject;
  
  // assigning from email
  $params['from']       = $fromEmail;
  
  #### live ###### uncomment it
  $params['toName']     = $displayName;
  $params['toEmail']    = $email;
        
  #### test ###### comment it
  #$params['toName']       = "Test";
  #$params['toEmail']      = 'rajesh@millertech.co.uk';
  
  # Left this in as hard coded for now as the default from email address doesn't seem to work
  # We can probably do something with the contribution type for the from email addresses
  $params['from']         = 'noreply@example.com';
    
  $attach = array('fullPath'=>$filePathName,
          'mime_type'=>'pdf',
          'cleanName'=>$fileName);
          
  ## Commented out to test if attachments are causing the problem
  $params['attachments'] = array($fileName => $attach);
  
  require_once 'CRM/Utils/Mail.php';

  // Comment to abort sending email
  $sent = CRM_Utils_Mail::send( $params);
  
  if($sent) {
    echo "<br />Invoice sent <b>successfully</b> - {$email}</b><br /><br />";
    ## Insert a record into Log table - civicrm_mtl_invoice_log
    $contribution_id = $contribution->id;
  }  
  else {
    echo "<br />Invoice sent <b>faliure</b> - <b>{$email}</b>$sent->message<br /><br />";
  }
    
  //please comment this before setting up in LIVE 
  //exit;
}

run( $argc, $argv );
//run();

?>
