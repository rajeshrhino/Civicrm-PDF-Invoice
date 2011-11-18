-- 
--  Copyright (C) 2010 Miller Technology
--  @license GNU General Public License version 2 or later
--  


-- phpMyAdmin SQL Dump
-- version 3.2.0.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 21, 2010 at 01:50 PM
-- Server version: 5.1.36
-- PHP Version: 5.3.0

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `civicrm_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `civicrm_invoice`
--

CREATE TABLE IF NOT EXISTS `civicrm_invoice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Invoice Id',
  `invoice_no` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Invoice Reference Number',
  `participant_id` int(10) unsigned DEFAULT NULL COMMENT 'Participant ID',
  `contribution_id` int(10) unsigned DEFAULT NULL COMMENT 'Contribution ID',
  `language_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Language to be used for invoice - from Language settings of contact',
  `date_created` datetime DEFAULT NULL COMMENT 'System created date',
  `date_cancelled` datetime DEFAULT NULL COMMENT 'If invoice is cancelled this date will be set',
  `date_paid` datetime DEFAULT NULL COMMENT 'Invoice Paid date',
  `date_raised` date DEFAULT NULL COMMENT 'When transaction was created',
  `date_due` date DEFAULT NULL COMMENT 'Payment Due date',
  `addressed_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Payment Due date',
  `attention_of` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Payment Due date',
  `address_line1` varchar(96) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Payment Due date',
  `address_line2` varchar(96) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Payment Due date',
  `address_line3` varchar(96) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Payment Due date',
  `town` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Which town does this address belong to.',
  `city` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Which City does this address belong to.',
  `postcode` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Postal code',
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Which County does this address belong to.',
  `currency` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Currency for invoice',
  `special_instructions` text COLLATE utf8_unicode_ci COMMENT 'Displayed on invoice, any special instructions',
  `item_descr_column_heading` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Item headings',
  `invoice_amount` decimal(20,3) DEFAULT NULL COMMENT 'Total Invoice Amount before any discounts etc',
  `net_amount` decimal(20,3) DEFAULT NULL COMMENT 'Net Invoice Amount (Total Amount Minus any Fees/Charges)',
  `fee_amount` decimal(20,3) DEFAULT NULL COMMENT 'Total Fee amount (Discounts/Fees added)',
  `company_tax_no` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Tax/Payment No required on invoice',
  `post_invoice` tinyint(4) DEFAULT NULL COMMENT 'Do we need to post also',
  `email_invoice_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Email address we need to send to.',
  `email_school_address` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `invoice_paid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `additional_message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `civicrm_invoice_item`
--

CREATE TABLE IF NOT EXISTS `civicrm_invoice_item` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Invoice Item Id',
  `invoice_id` int(10) unsigned NOT NULL COMMENT 'Invoice Id',
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Description of the item',
  `qty` int(10) unsigned DEFAULT NULL COMMENT 'Quantity',
  `unit_amount` decimal(20,3) DEFAULT NULL COMMENT 'Unit Cost before discounts etc',
  `net_amount` decimal(20,3) DEFAULT NULL COMMENT 'Net Amount (Unit Amount Minus any Fees/Charges)',
  `fee_amount` decimal(20,3) DEFAULT NULL COMMENT 'Total Fee amount (Discounts/Fees added * QTY)',
  `vat` decimal(20,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_civicrm_invoice_item_invoice_id` (`invoice_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `civicrm_invoice_item`
--
ALTER TABLE `civicrm_invoice_item`
ADD CONSTRAINT `FK_civicrm_invoice_item_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `civicrm_invoice` (`id`);
