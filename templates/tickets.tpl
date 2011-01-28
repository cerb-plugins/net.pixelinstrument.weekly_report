{if sizeof($tickets)}
    <h2>Tickets Update</h2>
    
    {assign var=open_tickets value=false}
    {assign var=wfr_tickets value=false}
    {assign var=closed_tickets value=false}
    
    {foreach from=$tickets key=t_id item=ticket}
        {if $ticket.t_is_closed}
            {assign var=closed_tickets value=true}
        {elseif $ticket.t_is_waiting}
            {assign var=wfr_tickets value=true}
        {else}
            {assign var=open_tickets value=true}
        {/if}
    {/foreach}
    
    <table class="update_table">
        <tr>
            <td colspan="5">
                <h3>Assigned tickets: {$assigned_tickets}</h3>
                <h3>Tickets worked on: {$responded_tickets}</h3>
            </td>
        </tr>

        {if $open_tickets}
            <tr>
                <td><h3 class="green">Open Tickets</h3></td>
                <td colspan="3"></td>
                <td class="center strong">SLA</td>
                <td class="center strong">Latest Response</td>
            </tr>
            {foreach from=$tickets key=t_id item=ticket}
                {if !$ticket.t_is_closed && !$ticket.t_is_waiting}
                    {include file="devblocks:net.pixelinstrument.weekly_report::single_ticket.tpl" ticket_class='green'}
                {/if}
            {/foreach}
            <tr><td colspan="6" style="height: 5px"></td></tr>
        {/if}
        
        {if $wfr_tickets}
            <tr>
                <td><h3 class="yellow">WFR Tickets</h3></td>
                <td colspan="3"></td>
                <td class="center strong">SLA</th>
                <td class="center strong">Latest Response</td>
            </tr>
            {foreach from=$tickets key=t_id item=ticket}
                {if !$ticket.t_is_closed && $ticket.t_is_waiting}
                    {include file="devblocks:net.pixelinstrument.weekly_report::single_ticket.tpl" ticket_class='yellow'}
                {/if}
            {/foreach}
            <tr><td colspan="6" style="height: 5px"></td></tr>
        {/if}
        
        {if $closed_tickets}
            <tr>
                <td><h3 class="red">Closed Tickets</h3></td>
                <td colspan="3"></td>
                <td class="center strong">SLA</td>
                <td class="center strong">Latest Response</td>
            </tr>
            {foreach from=$tickets key=t_id item=ticket}
                {if $ticket.t_is_closed}
                    {include file="devblocks:net.pixelinstrument.weekly_report::single_ticket.tpl" ticket_class='red'}
                {/if}
            {/foreach}
            <tr><td colspan="6" style="height: 5px"></td></tr>
        {/if}
    </table>
    
    {if !$otherworker}
        {literal}
        <script type="text/javascript">
            function reloadTickets() {
                $.get('{/literal}{devblocks_url}c=weeklyreport&a=reloadTickets{/devblocks_url}{literal}',
                    null,
                    function(out) {
                        $("#tickets_list").html(out);
                    },
                    'html'
                );    
            }
        
            $(function() {
                // assign function to call when a task title is clicked
                
                $('.ticket_link').bind('click', function() {
                    var t_id = this.id.match(/^ticket_link_([0-9]+)$/);
                    if (t_id) {
                        $popup = genericAjaxPopup('peek','c=tickets&a=showPreview&tid='+t_id[1],null,false,'550');
                        $popup.one('ticket_save', function(event) {
                            event.stopPropagation();
                            reloadTickets();
                        });
                    }
                });
                
                $('.ticket_org').bind('click', function() {
                    var o_id = this.id.match(/^ticket_org_([0-9]+)$/);
                    if (o_id) {
                        $popup = genericAjaxPopup('peek','c=contacts&a=showOrgPeek&id=' + o_id[1],null,false,'550');
                        $popup.one('org_save', function(event) {
                            event.stopPropagation();
                            reloadTickets();
                        });
                    }
                });
            });
        </script>
        {/literal}
    {/if}
{/if}
    