# {$active_worker->getName()} Weekly Report #

## GOALS FOR THIS WEEK ##

{$currentgoals}


## ACCOMPLISHMENTS THIS WEEK ##

{$accomplishments}


## GOALS FOR NEXT WEEK ##

{$nextgoals}


## CONCERNS ##

{$concerns}


## TASKS ##
{foreach from=$tasks key=t_id item=task}
### {$task.t_title} ### 
 - Due date: {$task.t_due_date|date_format} 
 - Completed: {if $task.t_is_completed}{$task.t_completed_date|date_format}{else}No{/if} 
 - Customers: {foreach from=$task.t_orgs key=org_id item=org}{$org.c_name} {/foreach} 

{assign var=last_note_created value=-1}
{foreach from=$task.t_notes item="note"}
{assign var=address_id value=$note->address_id}
{assign var=note_created value=$note->created|date_format|string_format:"%s"}
{if $last_note_created != $note_created}
{$last_note_created = $note_created}
__{$last_note_created}__
{/if}
		
{if $note->created > $last_update_time}[NEW] {/if}{if isset($workers.$address_id)}{$workers.$address_id->getName()}:{/if}

{$note->comment}

{/foreach}


{/foreach}

## CUSTOMERS ##
{foreach from=$customers key=c_id item=customer}
### {$customer.c_name} ### 

{assign var=last_note_created value=-1}
{foreach from=$customer.c_notes item="note"}
{assign var=address_id value=$note->address_id}
{assign var=note_created value=$note->created|date_format|string_format:"%s"}
{if $last_note_created != $note_created}
{$last_note_created = $note_created}
__{$last_note_created}__
{/if}
		
{if $note->created > $last_update_time}[NEW] {/if}{if isset($workers.$address_id)}{$workers.$address_id->getName()}:{/if}

{$note->comment}

{/foreach}


{/foreach}