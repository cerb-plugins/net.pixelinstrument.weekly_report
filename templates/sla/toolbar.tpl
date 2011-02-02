<div style="padding: 4px; {if $ticket_sla > 0 && $first_update > $ticket_sla}color:#C00;{/if}">
	<span class="cerb-sprite sprite-stopwatch" style="padding-bottom: 4px"></span>
	<strong>SLA:</strong> {$ticket_sla} day{if $ticket_sla!=1}s {if $customer_type}({$customer_type}){/if}{/if}
	| <strong>First Response:</strong> in {$first_update} day{if $first_update!=1}s{/if}
	| <strong>Last Response:</strong> {$last_update} day{if $last_update!=1}s{/if} ago
</div>