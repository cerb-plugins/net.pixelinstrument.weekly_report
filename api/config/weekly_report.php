<?php
class PiWeeklyReportConfigTab extends Extension_ConfigTab {
	const ID = 'net.pixelinstrument.weekly_report.config.tab';
	
	function showTab() {
		$tpl = DevblocksPlatform::getTemplateService();
        
        $properties = PiWeeklyReportPage::_getProperties();
        $tpl->assign('properties', $properties);
        
        $destinations = CerberusApplication::getHelpdeskSenders();
        $tpl->assign('destinations', $destinations);
        
        $customer_fields = DAO_CustomField::getByContext(CerberusContexts::CONTEXT_ORG);
        $tpl->assign('customer_fields', $customer_fields);
        
        $ticket_fields = DAO_CustomField::getByContext(CerberusContexts::CONTEXT_TICKET);
		$tpl->assign('ticket_fields', $ticket_fields);
        
		$tpl->display('devblocks:net.pixelinstrument.weekly_report::configure.tpl');
	}
    
    function saveTab() {
        $destinations = CerberusApplication::getHelpdeskSenders();
        $main_mail_send_to = current ($destinations);

        @$task_list_days = DevblocksPlatform::importGPC($_REQUEST['task_list_days'], 'integer', 14);
        @$customer_list_days = DevblocksPlatform::importGPC($_REQUEST['customer_list_days'], 'integer', 14);
        @$ticket_list_days = DevblocksPlatform::importGPC($_REQUEST['ticket_list_days'], 'integer', 14);
        @$from = DevblocksPlatform::importGPC($_REQUEST['from'],'string', "");
        @$send_to = DevblocksPlatform::importGPC($_REQUEST['send_to'],'string', $main_mail_send_to);
        @$product_field_id = DevblocksPlatform::importGPC($_REQUEST['product_field_id'],'integer', 0);
               
        $properties = array();
		$properties['task_list_days'] = $task_list_days;
        $properties['customer_list_days'] = $customer_list_days;
        $properties['ticket_list_days'] = $ticket_list_days;
        $properties['from'] = $from;
        $properties['send_to'] = $send_to;
        $properties['product_field_id'] = $product_field_id;
        
        DAO_DevblocksExtensionPropertyStore::put(PiWeeklyReportPage::ID, 'properties', serialize ($properties));
        
		DevblocksPlatform::redirect(new DevblocksHttpResponse(array('config','weeklyreport')));
		exit;
	}
};


?>
