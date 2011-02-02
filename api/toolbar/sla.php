<?php
if (class_exists('Extension_TicketToolbarItem',true)):
	class AppceleratorToolbarSLA extends Extension_TicketToolbarItem {
		function render(Model_Ticket $ticket) {
			$tpl = DevblocksPlatform::getTemplateService();
			
			$properties = PiWeeklyReportPage::_getProperties();
			
			list($tickets_messages) = DAO_Message::search(
				array(
					new DevblocksSearchCriteria(SearchFields_Message::TICKET_ID, DevblocksSearchCriteria::OPER_EQ, $ticket->id),
					new DevblocksSearchCriteria(SearchFields_Message::IS_OUTGOING, '=', 1),
				),
				-1,
				0,
				SearchFields_Message::CREATED_DATE,
				true,
				false
			);
			
			$now = time();
			
			$first_response_date = $now;
			$last_response_date = 0;
			
			foreach ($tickets_messages as $message) {
				$t_id = $message[SearchFields_Message::TICKET_ID];
				
				if ($first_response_date > $message[SearchFields_Message::CREATED_DATE])
					$first_response_date = $message[SearchFields_Message::CREATED_DATE];
					
				if ($last_response_date < $message[SearchFields_Message::CREATED_DATE]) {
					$last_response_date = $message[SearchFields_Message::CREATED_DATE];
				}
			}
			
			$sla = 0;
			$customer_id = 0;
			
			// Get the customer id
            $address = DAO_Address::get ($ticket->first_wrote_address_id);
			if ($address)
				$customer_id = $address->contact_org_id;
				
			if ($customer_id) {
				$customer_custom_values = DAO_CustomFieldValue::getValuesByContextIds(CerberusContexts::CONTEXT_ORG, $customer_id);
				
				$customer_type_field_id = $properties['customer_type_field_id'];
				$customer_type = "";
				if ($customer_id &&
					$customer_type_field_id &&
					isset ($customer_custom_values[$customer_id]) &&
					isset ($customer_custom_values[$customer_id][$customer_type_field_id]))
				{
					
					$customer_type = $customer_custom_values[$customer_id][$customer_type_field_id];

					$sla = isset ($properties['sla'][$customer_type]) ? ($properties['sla'][$customer_type]) : 0;
				}
			}
			
			$tpl->assign ('ticket_sla', $sla);
			$tpl->assign ('customer_type', $customer_type);
            $tpl->assign ('first_update', PiWeeklyReportPage::calculateWorkingDays ($ticket->created_date, $first_response_date));
			$tpl->assign ('last_update', PiWeeklyReportPage::calculateWorkingDays ($last_response_date, $now));
			
			$tpl->display('devblocks:net.pixelinstrument.weekly_report::sla/toolbar.tpl');
		}
	};
endif;
