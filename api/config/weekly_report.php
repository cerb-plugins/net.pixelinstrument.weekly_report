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

		@$show_sla_bar = DevblocksPlatform::importGPC($_REQUEST['show_sla_bar'], 'string', 0);
        @$task_list_days = DevblocksPlatform::importGPC($_REQUEST['task_list_days'], 'integer', 14);
        @$customer_list_days = DevblocksPlatform::importGPC($_REQUEST['customer_list_days'], 'integer', 14);
        @$ticket_list_days = DevblocksPlatform::importGPC($_REQUEST['ticket_list_days'], 'integer', 14);
        @$from = DevblocksPlatform::importGPC($_REQUEST['from'],'string', "");
        @$send_to = DevblocksPlatform::importGPC($_REQUEST['send_to'],'string', $main_mail_send_to);
        @$working_days = DevblocksPlatform::importGPC($_REQUEST['working_days'],'array', array(1,2,3,4,5));
        @$holiday_name = DevblocksPlatform::importGPC($_REQUEST['holiday_name'],'array', array());
        @$holiday_date = DevblocksPlatform::importGPC($_REQUEST['holiday_date'],'array', array());
        @$customer_type_field_id = DevblocksPlatform::importGPC($_REQUEST['customer_type_field_id'],'integer', 0);
        @$product_field_id = DevblocksPlatform::importGPC($_REQUEST['product_field_id'],'integer', 0);
        
        @$sla_opt = DevblocksPlatform::importGPC($_REQUEST['sla_opt'],'array', array());
        @$sla = DevblocksPlatform::importGPC($_REQUEST['sla'],'array', array());
        
        // write all dates as YYYY-MM-DD
        $holidays = array();
        foreach ($holiday_date as $key => $date) {
            $time = strtotime($date);
            $name = $holiday_name[$key];
            
            if (strlen($name) && $time > 0) {
                $holidays[date ("Y-m-d", $time)] = $name;
            }
        }
        
        $properties = array();
		$properties['show_sla_bar'] = $show_sla_bar;
        $properties['task_list_days'] = $task_list_days;
        $properties['customer_list_days'] = $customer_list_days;
        $properties['ticket_list_days'] = $ticket_list_days;
        $properties['from'] = $from;
        $properties['send_to'] = $send_to;
        $properties['working_days'] = $working_days;
        $properties['holidays'] = $holidays;
        $properties['customer_type_field_id'] = $customer_type_field_id;
        $properties['product_field_id'] = $product_field_id;
        $properties['sla'] = (sizeof ($sla_opt) && sizeof ($sla)) ? array_combine ($sla_opt, $sla) : array();
        
        DAO_DevblocksExtensionPropertyStore::put(PiWeeklyReportPage::ID, 'properties', serialize ($properties));
        
		DevblocksPlatform::redirect(new DevblocksHttpResponse(array('config','weeklyreport')));
		exit;
	}
};


?>
