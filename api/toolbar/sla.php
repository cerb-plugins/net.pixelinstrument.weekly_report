<?php
if (class_exists('Extension_TicketToolbarItem',true)):
	class AppceleratorToolbarSLA extends Extension_TicketToolbarItem {
		function render(Model_Ticket $ticket) {
			$tpl = DevblocksPlatform::getTemplateService();
			
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
			
			foreach ($tickets_messages as $message) {
				$t_id = $message[SearchFields_Message::TICKET_ID];
				
				if (!isset($tickets[$t_id]['t_first_response_time']) || $tickets[$t_id]['t_first_response_time'] > $message[SearchFields_Message::CREATED_DATE]) {
					$tickets[$t_id]['t_first_response_time'] = $message[SearchFields_Message::CREATED_DATE];
				}
			}
			
			if (isset ($ticket->t_first_response_time))
                $response_date = $ticket->t_first_response_time;
            else
                $response_date = $now;
            
            $tpl->assign ('ticket_sla', PiWeeklyReportPage::calculateWorkingDays ($ticket->created_date, $response_date));
			
			$tpl->display('devblocks:net.pixelinstrument.weekly_report::sla/toolbar.tpl');
		}
	};
endif;
