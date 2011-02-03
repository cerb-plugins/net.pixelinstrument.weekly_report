<div style="padding: 4px;">
	<span class="cerb-sprite sprite-stopwatch" style="padding-bottom: 4px"></span>
	<strong>SLA:</strong>
		<span>{$ticket_sla} day{if $ticket_sla!=1}s {if $customer_type}({$customer_type}){/if}{/if}</span>
		
	|
	
	<strong>First Response:</strong>
		<span {if $no_response || ($ticket_sla > 0 && $first_update > $ticket_sla)}style="color:#C00;"{/if}>{if $no_response}none {/if}in {$first_update} day{if $first_update!=1}s{/if}</span>
		
	|
	
	<strong>Last Response:</strong> <span {if $no_response}style="color:#C00;"{/if}>{if $no_response}never{else}{$last_update} day{if $last_update!=1}s{/if} ago{/if}</span>
</div>