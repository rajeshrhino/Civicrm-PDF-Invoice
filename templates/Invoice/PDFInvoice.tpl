{**
* Copyright (C) 2010 Miller Technology
* @license GNU General Public License version 2 or later
*}

<html>
	<head>
		<title>{$InvoiceTitle}</title>
		<link rel="stylesheet" href="{$CssAndImagePath}invoice.css" type="text/css" />
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	</head>

	<body>
		<table>
			<tr>
				<td align="left" width="50%">
					<h1>{$InvoiceTitle}</h1>
				</td>
				<td align="right">
					<img src="{$CssAndImagePath}logo.gif" class="logo"  />
				</td>
			</tr>
			<tr>
				<td>
					{if $addressed_to != null}
						{$addressed_to}<br />
					{/if}

					{if $address_line1 != null}
						{$address_line1}<br />
					{/if}
					{if $address_line2 != null}
						{$address_line2}<br />
					{/if}
					{if $address_line3 != null}
					  {$address_line3}<br />
					{/if}
					{if $town != null}
					  {$town}<br />
					{/if}
					{if $postcode != null}
					  {$postcode},                            
					{/if}
					{if $city != null}
					  {$city}<br />
					{/if}
					{if $country != null}
					  {$country}<br />
					{/if}
					<br />
					{if $company_tax_no != null}
					  {$company_tax_no}
					{/if}
				</td>
				<td align="right">
					<b>{if $CompanyName != null} {$CompanyName} {/if} <br />
					{if $CompanyAddressLine1 != null} {$CompanyAddressLine1} {/if}<br />
					{if $CompanyCity != null} {$CompanyCity} {/if}
					{if $CompanyPostCode != null} {$CompanyPostCode} {/if}
          </b>
				</td>
			</tr>
			<tr>
				<td colspan="2"><br /><br /></td>
			</tr>
			<tr>
				<td colspan="2" align="left">
					  <table cellspacing="0" cellpadding="0" border="0">
					  <tr>
					  <td>
					  <b>{$InvoiceNoLabel}:</b> {$invoice_no}<br />
					  <b>{$InvoiceDateLabel}:</b> {$invoice_date|crmDate}<br />
					  {if $invoice_due_date != null}<b>{$InvoiceDueDateLabel}:</b> {$invoice_due_date|crmDate} {/if}
					  </td>
					  <td align="right">
					  {if $CompanyTelephone != null }Tel: {$CompanyTelephone} {/if}
					  {if $CompanyFax != null }Fax: {$CompanyFax} {/if} <br />
					  {if $CompanyEmail != null }Email: {$CompanyEmail} {/if}<br />
					  {if $CompanyWebsite != null }
					  <a href="{$CompanyWebsite}">{$CompanyWebsite}</a>
					  {/if}
					  </td>
					  </tr>
					  </table>
					  <br /><br /><br />
					</td>
					</tr>
					{if $special_instructions != null}
					  <tr>
					  <td colspan="2">
					  <b>{$YourReferenceLabel}:</b> {if $special_instructions|trim != ''}{$special_instructions}{else}N/A{/if}<br /><br />
					  </td>
					  </tr>
					{/if}
					</table>
				</td>
			</tr>
		</table>

		<table>
			<tr>
				<td class="borderedcell"><b>{$item_descr_column_heading}</b></td>
				<td class="borderedcell" align="right"></b>Net</td>
				<td class="borderedcell" align="right"></b>Discount</td>
				<td class="borderedcell" align="right"></b>VAT</td>
				<td class="borderedcell" align="right"></b>Total</td>
			</tr>
	
			{assign var="sub_total" value=0.00}
			{assign var="total_vat" value=0.00}
			{foreach from=$invoiceItems item=invoiceItem}
				<tr>
					<td class="borderedcell">
						{$invoiceItem.description|strip_tags}
					</td>
					<td class="borderedcell" align="right">
						{$invoiceItem.fee_amount|string_format:"%.2f"|crmMoney:$currency}
					</td>
					<td class="borderedcell" align="right">
						{0.00|string_format:"%.2f"|crmMoney:$currency}
					</td>
					<td class="borderedcell" align="right">
						{$invoiceItem.vat|string_format:"%.2f"|crmMoney:$currency}
					</td>
					<td class="borderedcell" align="right">
						{$invoiceItem.fee_amount+$invoiceItem.vat|string_format:"%.2f"|crmMoney:$currency}
						{assign var="sub_total_exc_vat" value=$sub_total+$invoiceItem.fee_amount}
						{assign var="sub_total" value=$sub_total+$invoiceItem.fee_amount}
						{assign var="sub_total" value=$sub_total+$invoiceItem.vat}
						{assign var="total_vat" value=$total_vat+$invoiceItem.vat}
					</td>
					
				</tr>
			{/foreach}
			<tr>
				<td class="borderedcell">
					Subtotal
				</td>
				<td class="borderedcell" align="right">
					{$sub_total_exc_vat|string_format:"%.2f"|crmMoney:$currency}
				</td>
				<td class="borderedcell" align="right">
					{0.00|string_format:"%.2f"|crmMoney:$currency}
				</td>
				<td class="borderedcell" align="right">
					{$total_vat|string_format:"%.2f"|crmMoney:$currency}
				</td>
				<td class="borderedcell" align="right">
					{$sub_total|string_format:"%.2f"|crmMoney:$currency}
				</td>
			</tr>

			<tr>
				<td class="borderedcell" colspan="4"><b>INVOICE TOTAL</b></td>
				<td class="borderedcell" align="right"><b>{$fee_amount|string_format:"%.2f"|crmMoney:$currency}</b></td>
			</tr>
</table>

<br />
<br />
<h2><center>{$PaymentDetailsLabel}</center></h2>
<br />
<br />


<table>
	<tr>
		<td rowspan="2" class="borderedcell">
			
			{if $BankName != null } <b> {$BankLabel}:</b> {$BankName}<br /> {/if}
      {if $BankAccountName != null } <b> {$AccountNameLabel}:</b> {$BankAccountName}<br /> {/if}
			{if $BankAccountNumber != null } <b> {$AccountNumberLabel}:</b> {$BankAccountNumber}<br /> {/if}
			{if $BankSortCode != null } <b> GB Bank Sort Code:</b> {$BankSortCode}<br /> {/if}
			{if $BankSwift != null } <b> SWIFT/BIC:</b> {$BankSwiftCode}<br /> {/if}
			
		</td>
		<td class="borderedcell" align="left" valign="top">
			<b><span class="red">
				{$InvoiceHelpTextPreInvoiceNo}{$invoice_no}{$InvoiceHelpTextPostInvoiceNo}
			</span></b>
		</td>
	</tr>
	<tr>
		<td class="borderedcell" align="left" valign="top">
			{if $email_invoice_address != ""} Invoice emailed to {$email_invoice_address} <br />{/if}
		</td>
	</tr>
</table>
<br />
<br />
{if $CompanyVatRegistrationNumber != null}
VAT Registration number: {$CompanyVatRegistrationNumber}
<br />
<br />
{/if}
{if $invoice_paid != null}
<center><h1>{$invoice_paid}</h1></center>
{/if}
{if $additional_message != null}
<center><h3>{$additional_message}</h3></center>
{/if}
<br />
<br />
{if $CompanyFooterNode != null}
<center><span class="footer">
{$CompanyFooterNode}
</span
</center>
{/if}
</body>
</html>
