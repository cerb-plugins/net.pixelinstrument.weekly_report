<tr class="ticket {$ticket_class}">
	<td class="left narrow">
		<a id="ticket_link_{$t_id}" class="strong big ticket_link" href="javascript:;">{$ticket.t_mask}</a>
	</td>
    
    <td class="left narrow">
        {if $ticket.t_first_contact_org_id}
            <a href="javascript:;" id="ticket_org_{$ticket.t_first_contact_org_id}" class="ticket_org">{$ticket.o_name}</a>
        {else}
            No customer
        {/if}
	</td>
    
    <td class="narrow left">{$ticket.t_product}</td>
	
	<td class="left">
		<strong>{$ticket.t_subject}</strong>
	</td>
    
	{if $sla_available}
		<td class="normal">
			<span class="customer_type">{$ticket.t_sla_info.customer_type|upper}</span>
			<span class="label {$ticket.t_sla_info.sla_status}">
				{$ticket.t_sla_info.sla_days} {if $ticket.t_sla_info.sla_type == 'b'}business{/if} day{if $ticket.t_sla_info.sla_days != 1}s{/if}
			</span>
		</td>
    
		<td class="narrow">
			{if $ticket.t_sla_info.last_response_time > 0}
				{$ticket.t_sla_info.last_response_time|devblocks_prettytime}
			{else}
				---
			{/if}
		</td>
	{/if}
</tr>
