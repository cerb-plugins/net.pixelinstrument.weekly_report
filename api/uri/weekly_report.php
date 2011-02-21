<?php
class PiWeeklyReportPage extends CerberusPageExtension {
    const ID = 'net.pixelinstrument.weekly_report.page';
    
	function __construct($manifest) {
		parent::__construct($manifest);
	}
		
	function isVisible() {
		// check login
		$visit = CerberusApplication::getVisit();
		
		if(empty($visit)) {
			return false;
		} else {
			return true;
		}
	}
    
    static function calculateWorkingDays ($start, $end) {
        $properties = self::_getProperties();
        
        if ($end < $start)
            return 0;
        
        $holidays = array_keys ($properties['holidays']);
        
        $working_days = $properties['working_days'];
        
        $start_date = date ("Y-m-d", $start);
        $end_date = date ("Y-m-d", $end);
        
        $cur_date = $start_date;
        
        $num_days = 0;
        while ($cur_date != $end_date) {
            if (in_array (date("w", strtotime ($cur_date)), $working_days)) {
                if (!in_array ($cur_date, $holidays)) {
                    $num_days++;
                }
            }
            
            $cur_date = date ("Y-m-d", strtotime ("+1 days", strtotime($cur_date)));
        }
        
        return $num_days;
    }
	
	function render() {
		$tpl = DevblocksPlatform::getTemplateService();
        
        $active_worker = $this->_getActiveWorker();
        $tpl->assign('active_worker', $active_worker);
        
        $current_worker = CerberusApplication::getActiveWorker();
        if ($active_worker->id != $current_worker->id)
            $tpl->assign('otherworker', true);
        
        $active_worker_address_id = $active_worker->getAddress()->id;
        $tpl->assign('active_worker_address_id', $active_worker_address_id);
        
        $workers = DAO_Worker::getAll();
        $tpl->assign('workers', $workers);
		
        $properties = self::_getProperties();
        $tpl->assign('properties', $properties);
        
        $last_update_time = $this->_getLastUpdateTime();
        $tpl->assign('last_update_time', $last_update_time);
        
        $tasks = $this->_getTasks();
        $tpl->assign('tasks', $tasks);
        
        $customers = $this->_getCustomers();
        $tpl->assign('customers', $customers);
        
        list($tickets, $assigned_tickets, $responded_tickets) = $this->_getTickets();
		$tpl->assign('sla_available', (class_exists('PiSlaUtils',true) && DevblocksPlatform::isPluginEnabled('net.pixelinstrument.sla')));
        $tpl->assign('tickets', $tickets);
        $tpl->assign('assigned_tickets', $assigned_tickets);
        $tpl->assign('responded_tickets', $responded_tickets);
        
        $worker_settings = $this->_getWorkerSettings();
        $tpl->assign('worker_settings', $worker_settings);
        
		$tpl->display('devblocks:net.pixelinstrument.weekly_report::index.tpl');
	}

    // ajax
    function addTaskCommentAction() {
        @$comment = DevblocksPlatform::importGPC($_REQUEST['comment'],'string','');
        @$id = DevblocksPlatform::importGPC($_REQUEST['id'],'integer','');
        
        $active_worker = $this->_getActiveWorker();
        
        if(!empty($comment) && !empty($id)) {
			$fields = array(
				DAO_Comment::CONTEXT => CerberusContexts::CONTEXT_TASK,
				DAO_Comment::CONTEXT_ID => $id,
				DAO_Comment::ADDRESS_ID => $active_worker->getAddress()->id,
				DAO_Comment::CREATED => time(),
				DAO_Comment::COMMENT => $comment,
			);
			
            $note_id = DAO_Comment::create($fields);
		}
        exit;
    }
    
    function addCustomerCommentAction() {
        @$comment = DevblocksPlatform::importGPC($_REQUEST['comment'],'string','');
        @$id = DevblocksPlatform::importGPC($_REQUEST['id'],'integer','');
        
        $active_worker = $this->_getActiveWorker();
        
        if(!empty($comment) && !empty($id)) {
			$fields = array(
				DAO_Comment::CONTEXT => CerberusContexts::CONTEXT_ORG,
				DAO_Comment::CONTEXT_ID => $id,
				DAO_Comment::ADDRESS_ID => $active_worker->getAddress()->id,
				DAO_Comment::CREATED => time(),
				DAO_Comment::COMMENT => $comment,
			);
			
            $note_id = DAO_Comment::create($fields);
		}
        exit;
    }
    
    function deleteCommentAction() {
        @$id = DevblocksPlatform::importGPC($_REQUEST['id'],'integer','');
        
        //$active_worker = $this->_getActiveWorker();
        
        if(!empty($id)) {
			DAO_Comment::delete($id);
		}
        exit;
    }
    
    function reloadTasksAction() {
        $tpl = DevblocksPlatform::getTemplateService();
        
        $active_worker = $this->_getActiveWorker();
        $tpl->assign('active_worker', $active_worker);
        
        $active_worker_address_id = $active_worker->getAddress()->id;
        $tpl->assign('active_worker_address_id', $active_worker_address_id);
        
        $workers = DAO_Worker::getAll();
        $tpl->assign('workers', $workers);
		
        $properties = self::_getProperties();
        $tpl->assign('properties', $properties);
        
        $last_update_time = $this->_getLastUpdateTime();
        $tpl->assign('last_update_time', $last_update_time);
        
        $tasks = $this->_getTasks();
        $tpl->assign('tasks', $tasks);
        
        $tpl->display('devblocks:net.pixelinstrument.weekly_report::tasks.tpl');
        exit;
    }
    
    function reloadCustomersAction() {
        $tpl = DevblocksPlatform::getTemplateService();
        
        $active_worker = $this->_getActiveWorker();
        $tpl->assign('active_worker', $active_worker);
        
        $active_worker_address_id = $active_worker->getAddress()->id;
        $tpl->assign('active_worker_address_id', $active_worker_address_id);
        
        $workers = DAO_Worker::getAll();
        $tpl->assign('workers', $workers);
		
        $properties = self::_getProperties();
        $tpl->assign('properties', $properties);
        
        $last_update_time = $this->_getLastUpdateTime();
        $tpl->assign('last_update_time', $last_update_time);
        
        $customers = $this->_getCustomers();
        $tpl->assign('customers', $customers);
        
        $tpl->display('devblocks:net.pixelinstrument.weekly_report::customers.tpl');
        exit;
    }
    
    function reloadTicketsAction() {
        $tpl = DevblocksPlatform::getTemplateService();
        
        $active_worker = $this->_getActiveWorker();
        $tpl->assign('active_worker', $active_worker);
        
        $active_worker_address_id = $active_worker->getAddress()->id;
        $tpl->assign('active_worker_address_id', $active_worker_address_id);
        
        $workers = DAO_Worker::getAll();
        $tpl->assign('workers', $workers);
		
        $properties = self::_getProperties();
        $tpl->assign('properties', $properties);
        
        $last_update_time = $this->_getLastUpdateTime();
        $tpl->assign('last_update_time', $last_update_time);
        
        list($tickets, $assigned_tickets, $responded_tickets) = $this->_getTickets();
		$tpl->assign('sla_available', (class_exists('PiSlaUtils',true) && DevblocksPlatform::isPluginEnabled('net.pixelinstrument.sla')));
        $tpl->assign('tickets', $tickets);
        $tpl->assign('assigned_tickets', $assigned_tickets);
        $tpl->assign('responded_tickets', $responded_tickets);
        
        $tpl->display('devblocks:net.pixelinstrument.weekly_report::tickets.tpl');
        exit;
    }
    
    function sendReportAction() {
        $tpl = DevblocksPlatform::getTemplateService();
        
        @$accomplishments = DevblocksPlatform::importGPC($_REQUEST['accomplishments'],'string','');
        @$nextgoals = DevblocksPlatform::importGPC($_REQUEST['nextgoals'],'string','');
        @$concerns = DevblocksPlatform::importGPC($_REQUEST['concerns'],'string','');
        
        $active_worker = $this->_getActiveWorker();
        $properties = self::_getProperties();
        
        $worker_settings = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'worker_settings', array());
        if (!empty($worker_settings))
            $worker_settings = unserialize ($worker_settings);
            
        
        // send mail
        $mailTpl = DevblocksPlatform::getTemplateService();
        
        $mailTpl->assign('active_worker', $active_worker);
        $mailTpl->assign('properties', $properties);
        $mailTpl->assign('last_update_time', $this->_getLastUpdateTime());
        $mailTpl->assign('currentgoals', (isset ($worker_settings[$active_worker->id])?$worker_settings[$active_worker->id]['currentgoals']:''));
        $mailTpl->assign('accomplishments', $accomplishments);
        $mailTpl->assign('nextgoals', $nextgoals);
        $mailTpl->assign('concerns', $concerns);
        $mailTpl->assign('tasks', $this->_getTasks());
        $mailTpl->assign('customers', $this->_getCustomers());
        
        $workers = DAO_Worker::getAll();
        $mailTpl->assign('workers', $workers);
        
        $mailSubject = $active_worker->getName() . " Weekly Report " . date("r");
        $mailContent = $mailTpl->fetch('devblocks:net.pixelinstrument.weekly_report::mail.tpl');
        
        $to = $properties['send_to'];
        
        if ($to) {
            $sFrom = $properties['from'];
            if (!$sFrom) {
                $worker_settings[$active_worker->id]['nextgoals'] = $nextgoals;
                $worker_settings[$active_worker->id]['accomplishments'] = $accomplishments;
                $worker_settings[$active_worker->id]['concerns'] = $concerns;
                
                DAO_DevblocksExtensionPropertyStore::put(self::ID, 'worker_settings', serialize ($worker_settings));
                
                $tpl->display('devblocks:net.pixelinstrument.weekly_report::failure.tpl');
                return;
            }
            
            
            // create the new message
            
            $messageid = CerberusApplication::generateMessageId();
            
            $message = new CerberusParserMessage();
            $message->headers['date'] = date('r'); 
            $message->headers['to'] = $to;
            $message->headers['subject'] = $mailSubject;
            $message->headers['message-id'] = $messageid;
            $message->headers['x-cerberus-portal'] = 1;
            
            @$oldticketid = (isset ($worker_settings[$active_worker->id])?$worker_settings[$active_worker->id]['oldticketid']:'');
            
            if ($oldticketid) {
                $messages = DAO_Message::getMessagesByTicket($oldticketid);
                if ($messages) {
                    $last_message = array_pop($messages); /* @var $last_message Model_Message */
                    $last_message_headers = $last_message->getHeaders();
                    unset($messages);
                    
                    $message->headers['in-reply-to'] = $last_message_headers['message-id'];
                }
            }
            
            // Sender
            $fromList = imap_rfc822_parse_adrlist($sFrom,'');
            if(empty($fromList) || !is_array($fromList)) {
                return; // abort with message
            }
            $from = array_shift($fromList);
            $message->headers['from'] = $from->mailbox . '@' . $from->host; 
    
            $message->body = $mailContent;
            
            $ticket_id = CerberusParser::parseMessage($message, array('no_autoreply' => true));
            
            if ($ticket_id) {
                // save the nextgoals to show next time on the current goals
                // and remove the other saved settings
                    
                $worker_settings[$active_worker->id]['currentgoals'] = $nextgoals;
                $worker_settings[$active_worker->id]['nextgoals'] = '';
                $worker_settings[$active_worker->id]['accomplishments'] = '';
                $worker_settings[$active_worker->id]['concerns'] = '';
                $worker_settings[$active_worker->id]['oldticketid'] = $ticket_id;
                    
                DAO_DevblocksExtensionPropertyStore::put(self::ID, 'worker_settings', serialize ($worker_settings));
                
                // update the last update time
                $last_update_times = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'last_update_times', array());
                if (!empty($last_update_times))
                    $last_update_times = unserialize ($last_update_times);
                    
                $last_update_times[$active_worker->id] = time();
                    
                DAO_DevblocksExtensionPropertyStore::put(self::ID, 'last_update_times', serialize ($last_update_times));
                
                $tpl->display('devblocks:net.pixelinstrument.weekly_report::success.tpl');
            } else {
                $worker_settings[$active_worker->id]['nextgoals'] = $nextgoals;
                $worker_settings[$active_worker->id]['accomplishments'] = $accomplishments;
                $worker_settings[$active_worker->id]['concerns'] = $concerns;
                
                DAO_DevblocksExtensionPropertyStore::put(self::ID, 'worker_settings', serialize ($worker_settings));
        
                $tpl->display('devblocks:net.pixelinstrument.weekly_report::failure.tpl');
            }
        }
        
        exit;
    }
    
    function saveReportAction() {
        @$accomplishments = DevblocksPlatform::importGPC($_REQUEST['accomplishments'],'string','');
        @$nextgoals = DevblocksPlatform::importGPC($_REQUEST['nextgoals'],'string','');
        @$concerns = DevblocksPlatform::importGPC($_REQUEST['concerns'],'string','');
        
        $active_worker = $this->_getActiveWorker();
        
        $worker_settings = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'worker_settings', array());
        if (!empty($worker_settings))
            $worker_settings = unserialize ($worker_settings);
            
        $worker_settings[$active_worker->id]['nextgoals'] = $nextgoals;
        $worker_settings[$active_worker->id]['accomplishments'] = $accomplishments;
        $worker_settings[$active_worker->id]['concerns'] = $concerns;
            
        DAO_DevblocksExtensionPropertyStore::put(self::ID, 'worker_settings', serialize ($worker_settings));
        
        exit;
    }
    
    function _getActiveWorker() {
        $active_worker = null;
        
        $response = DevblocksPlatform::getHttpResponse();
		$stack = $response->path;
        
        if (is_array($stack)) {
            array_shift($stack); // weeklyreport
            
            if (sizeof($stack)) {
                $worker_id = array_shift($stack);
                $active_worker = DAO_Worker::get($worker_id);
            }
        }
        
        if (!$active_worker)
            $active_worker = CerberusApplication::getActiveWorker();
		
        return $active_worker;
    }
    
    static function _getProperties() {
        $destinations = CerberusApplication::getHelpdeskSenders();
        $main_mail_send_to = current ($destinations);
		
        // get properties
        $properties = array();
        
        $properties = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'properties', '');
        
        if (empty ($properties)) {
            $properties = array ();
        } else {
            $properties = unserialize ($properties);
        }
        
        
        // add default values
        
        if (!isset($properties['ticket_list_days']))
            $properties['ticket_list_days'] = 7;
        
        if (!isset($properties['task_list_days']))
            $properties['task_list_days'] = 14;
            
        if (!isset($properties['customer_list_days']))
            $properties['customer_list_days'] = 14;
            
        if (!isset($properties['send_to']))
            $properties['send_to'] = $main_mail_send_to;
            
        if (!isset($properties['customer_type_field_id']))
            $properties['customer_type_field_id'] = 0;
            
        if (!isset($properties['product_field_id']))
            $properties['product_field_id'] = 0;
            
        if (!isset($properties['from']))
            $properties['from'] = "";

        return $properties;
    }
    
    function _getWorkerSettings() {
        $active_worker = $this->_getActiveWorker();
        
        $worker_settings= DAO_DevblocksExtensionPropertyStore::get(self::ID, 'worker_settings', array());
        if (!empty($worker_settings)) {
            $worker_settings = unserialize ($worker_settings);
            return $worker_settings[$active_worker->id];
        }
        
        return array();
    }
    
    function _getLastUpdateTime() {
        $active_worker = $this->_getActiveWorker();
        
        // last update time
        $last_update_time = 0;
        $last_update_times = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'last_update_times', '');
        if (!empty($last_update_times)) {
            $last_update_times = unserialize ($last_update_times);
            
            if (isset($last_update_times[$active_worker->id])) {
                $last_update_time = $last_update_times[$active_worker->id];
            }
        }
        
        return $last_update_time;
    }
    
    function _getTasks() {
        $active_worker = $this->_getActiveWorker();
        $properties = self::_getProperties();
        
        $last_update_times = DAO_DevblocksExtensionPropertyStore::get(self::ID, 'last_update_times', array());
        $last_update_time = 0;
        if (!empty($last_update_times)) {
            $last_update_times = unserialize ($last_update_times);
            $last_update_time = $last_update_times[$active_worker->id];
        }
        
        // worker's tasks
        list ($tasks) = DAO_Task::search(
            array(),
            array(
                new DevblocksSearchCriteria(SearchFields_Task::VIRTUAL_WORKERS, DevblocksSearchCriteria::OPER_IN, array($active_worker->id)),
                new DevblocksSearchCriteria(SearchFields_Task::UPDATED_DATE, '>=', (mktime (0, 0, 0) - $properties['task_list_days']*24*60*60)),
                array (
                    DevblocksSearchCriteria::GROUP_OR,
                    new DevblocksSearchCriteria(SearchFields_Task::IS_COMPLETED, '=', 0),
                    new DevblocksSearchCriteria(SearchFields_Task::COMPLETED_DATE, '>', $last_update_time),
                ),
            ),
            -1,
            0,
            SearchFields_Task::UPDATED_DATE,
            false,
            false
        );
        
        $tasks_ids = array_keys($tasks);
        
        // task's notes
        $tasks_notes = DAO_Comment::getByContext (CerberusContexts::CONTEXT_TASK, $tasks_ids);
        uasort ($tasks_notes, create_function('$a, $b', "return strcmp(\$a->created,\$b->created);\n"));
        
        $start_date = (mktime(0, 0, 0) - $properties['task_list_days']*24*60*60);
        foreach ($tasks_notes as $note) {
            if ($note->created < $start_date)
                continue;
            
            if (!isset($tasks[$note->context_id]['t_notes']))
                $tasks[$note->context_id]['t_notes'] = array();
            
            $tasks[$note->context_id]['t_notes'][] = $note;
        }
        
        // task's organizations
        foreach ($tasks as $t_id => $task) {
            list ($task_orgs) = DAO_ContactOrg::search(
                array(),
                array(
                    new DevblocksSearchCriteria(SearchFields_ContactOrg::CONTEXT_LINK, DevblocksSearchCriteria::OPER_EQ, CerberusContexts::CONTEXT_TASK),
                    new DevblocksSearchCriteria(SearchFields_ContactOrg::CONTEXT_LINK_ID, DevblocksSearchCriteria::OPER_IN, $task[SearchFields_Task::ID]),
                ),
                -1,
                0,
                SearchFields_ContactOrg::NAME,
                true,
                false
            );
            
            $tasks[$t_id]['t_orgs'] = $task_orgs;
        }
        
        
        // task's workers
        foreach ($tasks as $t_id => $task) {
            $tasks[$t_id]['t_workers'] = CerberusContexts::getWorkers(CerberusContexts::CONTEXT_TASK, $t_id);
        }
        
        return $tasks;
    }
    function _getCustomers() {
        $active_worker = $this->_getActiveWorker();
        $properties = self::_getProperties();
        
        // worker's customers
        list ($customers) = DAO_ContactOrg::search(
            array(),
            array(
                new DevblocksSearchCriteria(SearchFields_ContactOrg::CONTEXT_LINK, DevblocksSearchCriteria::OPER_EQ, CerberusContexts::CONTEXT_WORKER),
                new DevblocksSearchCriteria(SearchFields_ContactOrg::CONTEXT_LINK_ID, DevblocksSearchCriteria::OPER_IN, array($active_worker->id)),
            ),
            -1,
            0,
            SearchFields_ContactOrg::NAME,
            true,
            false
        );
        
        $customers_ids = array_keys($customers);
        
        // customer's notes
        $customers_notes = DAO_Comment::getByContext (CerberusContexts::CONTEXT_ORG, $customers_ids);
        uasort ($customers_notes, create_function('$a, $b', "return strcmp(\$a->created,\$b->created);\n"));
        
        $start_date = (mktime(0, 0, 0) - $properties['customer_list_days']*24*60*60);
        foreach ($customers_notes as $note) {
            if ($note->created < $start_date)
                continue;
            
            if (!isset($customers[$note->context_id]['c_notes']))
                $customers[$note->context_id]['c_notes'] = array();
            
            $customers[$note->context_id]['c_notes'][] = $note;
        }
        
        
        // customer's workers
        
        foreach ($customers as $c_id => $customer) {
            $customers[$c_id]['c_workers'] = CerberusContexts::getWorkers(CerberusContexts::CONTEXT_ORG, $c_id);
        }
        
        return $customers;
    }
    function _getTickets() {
        $active_worker = $this->_getActiveWorker();
        $properties = self::_getProperties();
        
        
        // first, find all the messages written by the active worker
        
        list ($messages) = DAO_Message::search(
            array(
                new DevblocksSearchCriteria(SearchFields_Message::WORKER_ID, DevblocksSearchCriteria::OPER_EQ, $active_worker->id),
                new DevblocksSearchCriteria(SearchFields_Message::CREATED_DATE, '>=', (mktime (0, 0, 0) - $properties['ticket_list_days']*24*60*60)),
            ),
            -1,
            0,
            SearchFields_Message::CREATED_DATE,
            true,
            false
        );
        
        
        // now, finds the ticket ids
        
        $responded_tickets_ids = array();
        foreach ($messages as $m_id => $message) {
            $t_id = $message[SearchFields_Message::TICKET_ID];
            
            if (!in_array($t_id, $responded_tickets_ids))
                array_push ($responded_tickets_ids, $t_id);
        }
        
        
        list ($worker_tickets) = DAO_Ticket::search(
            array (),
            array (
                new DevblocksSearchCriteria(SearchFields_Ticket::TICKET_UPDATED_DATE, '>=', (mktime (0, 0, 0) - $properties['ticket_list_days']*24*60*60)),
                new DevblocksSearchCriteria(SearchFields_Ticket::TICKET_DELETED, '=', 0),
                new DevblocksSearchCriteria(SearchFields_Ticket::VIRTUAL_WORKERS, DevblocksSearchCriteria::OPER_IN, array($active_worker->id)),
            ),
            -1,
            0,
            SearchFields_Ticket::TICKET_UPDATED_DATE,
            false,
            false
        );
        
        $worker_tickets_ids = array_keys ($worker_tickets);
        
        
        // time to find the ticket ids that belongs to the worker
        
        $tickets_ids = array_merge ($responded_tickets_ids, $worker_tickets_ids);
        
        
        // now get the tickets
        
        list ($tickets) = DAO_Ticket::search(
            array (
                'o_name'
            ),
            array (
                new DevblocksSearchCriteria(SearchFields_Ticket::TICKET_UPDATED_DATE, '>=', (mktime (0, 0, 0) - $properties['ticket_list_days']*24*60*60)),
                new DevblocksSearchCriteria(SearchFields_Ticket::TICKET_DELETED, '=', 0),
                new DevblocksSearchCriteria(SearchFields_Ticket::TICKET_ID, DevblocksSearchCriteria::OPER_IN, $tickets_ids),
            ),
            -1,
            0,
            SearchFields_Ticket::TICKET_UPDATED_DATE,
            false,
            false
        );
        
        
        // reload the tickets ids
        
        $tickets_ids = array_keys($tickets);
        $assigned_tickets = sizeof ($worker_tickets_ids);
        $responded_tickets = sizeof (array_intersect ($responded_tickets_ids, $tickets_ids));
        
        
        $tickets_custom_values = DAO_CustomFieldValue::getValuesByContextIds(CerberusContexts::CONTEXT_TICKET, array_keys ($tickets));
        
        foreach ($tickets as $t_id => $ticket) {
            // if we have the SLA plugin, let's include SLA
            if (class_exists('PiSlaUtils',true) && DevblocksPlatform::isPluginEnabled('net.pixelinstrument.sla')) {
				$ticket_sla_info = PiSlaUtils::getTicketSLAInfo ($t_id);
				
				$tickets[$t_id]['t_sla_info'] = $ticket_sla_info;
			}
            
            $product_field_id = $properties['product_field_id'];
            if ($product_field_id &&
                isset ($tickets_custom_values[$t_id]) &&
                isset ($tickets_custom_values[$t_id][$product_field_id])) {
            
                $tickets[$t_id]['t_product'] = $tickets_custom_values[$t_id][$product_field_id];
            }
        }
        
        return array ($tickets, $assigned_tickets, $responded_tickets);
    }
};

?>
