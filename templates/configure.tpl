<h1>Weekly Report settings</h1>

<form action="{devblocks_url}{/devblocks_url}" method="post" id="configWeeklyReport">
    <input type="hidden" name="c" value="config">
    <input type="hidden" name="a" value="saveTab">
    <input type="hidden" name="ext_id" value="net.pixelinstrument.weekly_report.config.tab">
	      
    Reports will come from:
    <input type="text" name="from" value="{$properties['from']}" /><br/><br/>
        
    Send reports to:
    <select name="send_to">
        <option value="">--- Select destination ---</option>
        {foreach from=$destinations item=destination}
            <option value="{$destination}" {if $properties['send_to'] == $destination}selected{/if}>{$destination}</option>
        {/foreach}
    </select><br/><br/>
    
    Product field:
    <select name="product_field_id">
            <option value="">--- Select ---</option>
            {foreach from=$ticket_fields item=f key=f_id}
                <option value="{$f_id}" {if $f_id == $properties['product_field_id']}selected{/if}>{$f->name}</option>
            {/foreach}
    </select><br/><br/>
    
    Show tasks' notes created in the last <input type="text" name="task_list_days" value="{$properties['task_list_days']}" style="width:20px" /> days<br/><br/>
    
    Show customers' notes created in the last <input type="text" name="customer_list_days" value="{$properties['customer_list_days']}" style="width:20px" /> days<br/><br/>
    
    Show tickets' updated in the last <input type="text" name="ticket_list_days" value="{$properties['ticket_list_days']}" style="width:20px" /> days<br/><br/>
    
    <button type="submit"><span class="cerb-sprite sprite-check"></span> {$translate->_('common.save_changes')|capitalize}</button>
</form>