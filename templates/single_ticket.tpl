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
    
    {if $ticket.t_sla == 0}
        {assign var=sla_class value="green"}
    {elseif $ticket.t_response_days > $ticket.t_sla}
        {assign var=sla_class value="red"}
    {elseif !$ticket.t_first_response_time}
        {assign var=sla_class value="yellow"}
    {else}
        {assign var=sla_class value="green"}
    {/if}
	<td class="normal">
        <span class="customer_type">{$ticket.t_customer_type|upper}</span>
        <span class="label {$sla_class}">
            {$ticket.t_response_days} day{if $ticket.t_response_days != 1}s{/if}
        </span>
	</td>
    
    <td class="narrow">
        {if $ticket.t_last_response_time}
            {$ticket.t_last_response_time|devblocks_prettytime}
        {else}
            ---
        {/if}
	</td>
</tr>
