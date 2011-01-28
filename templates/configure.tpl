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
    
    Customer type field <em>(used to calculate the SLA)</em>:
    <select name="customer_type_field_id">
            <option value="">--- Select ---</option>
            {foreach from=$customer_fields item=f key=f_id}
                <option value="{$f_id}" {if $f_id == $properties['customer_type_field_id']}selected{/if}>{$f->name}</option>
            {/foreach}
    </select><br/><br/>
    
    {assign var=customer_type_field_id value=$properties['customer_type_field_id']}
    {if $customer_type_field_id && isset($customer_fields.$customer_type_field_id)}
        SLA:<br/>
        {foreach from=$customer_fields.$customer_type_field_id->options item=opt}
            {$opt}: <input type="hidden" name="sla_opt[]" value="{$opt}" /><input type="text" name="sla[]" value="{$properties['sla'][$opt]}" style="width: 20px" /> days<br/>
        {/foreach}
    {/if}
    <br/>

    Show tasks' notes created in the last <input type="text" name="task_list_days" value="{$properties['task_list_days']}" style="width:20px" /> days<br/><br/>
    
    Show customers' notes created in the last <input type="text" name="customer_list_days" value="{$properties['customer_list_days']}" style="width:20px" /> days<br/><br/>
    
    Show tickets' updated in the last <input type="text" name="ticket_list_days" value="{$properties['ticket_list_days']}" style="width:20px" /> days<br/><br/>
    
    Working days:
        <input type="checkbox" name="working_days[]" value="0" {if in_array(0, $properties['working_days'])}checked{/if}>Sun
        <input type="checkbox" name="working_days[]" value="1" {if in_array(1, $properties['working_days'])}checked{/if}>Mon
        <input type="checkbox" name="working_days[]" value="2" {if in_array(2, $properties['working_days'])}checked{/if}>Tue
        <input type="checkbox" name="working_days[]" value="3" {if in_array(3, $properties['working_days'])}checked{/if}>Wed
        <input type="checkbox" name="working_days[]" value="4" {if in_array(4, $properties['working_days'])}checked{/if}>Thu
        <input type="checkbox" name="working_days[]" value="5" {if in_array(5, $properties['working_days'])}checked{/if}>Fri
        <input type="checkbox" name="working_days[]" value="6" {if in_array(6, $properties['working_days'])}checked{/if}>Sat
        <br/><br/>
        
    Holidays:
        <table>
            <tr><th>Name</th><th>Date</th></tr>
            {assign var=i value=0}
            {foreach from=$properties['holidays'] key=date item=name}
                <tr valign="top">
                    <td><input class="holiday_{$i}" type="text" name="holiday_name[]" value="{$name}" /></td>
                    <td>
                        <input class="holiday_{$i}" id="date_{$i}" type="text" name="holiday_date[]" value="{$date|date_format:"%A, %B %e, %Y"}" style="width: 200px" />
                        <button type="button" onclick="devblocksAjaxDateChooser('#date_{$i}','#choose_date_{$i}');"><span class="cerb-sprite sprite-calendar"></span></button>
                        <button type="button" onclick="$('.holiday_{$i}').val('')"><span class="cerb-sprite sprite-delete"></span></button>
                    </td>
                </tr>
                <tr><td colspan="2"><div id="choose_date_{$i}"></div></td></tr>
                {assign var=i value=$i+1}
            {/foreach}
            {for $x=1 to 5}
                <tr valign="top"><td><input class="holiday_{$i}" type="text" name="holiday_name[]" /></td>
                    <td>
                        <input class="holiday_{$i}" id="date_{$i}" type="text" name="holiday_date[]" style="width: 200px" />
                        <button type="button" onclick="devblocksAjaxDateChooser('#date_{$i}','#choose_date_{$i}');"><span class="cerb-sprite sprite-calendar"></span></button>
                        <button type="button" onclick="$('.holiday_{$i}').val('')"><span class="cerb-sprite sprite-delete"></span></button>
                    </td>
                </tr>
                <tr><td colspan="2"><div id="choose_date_{$i}"></div></td></tr>
                {assign var=i value=$i+1}
            {/for}
        </table><em>(save to see more fields)</em><br/><br/>
    
    <button type="submit"><span class="cerb-sprite sprite-check"></span> {$translate->_('common.save_changes')|capitalize}</button>
</form>