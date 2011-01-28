<h2>Weekly Update</h2>
<form id="weekly_report_form" action="{devblocks_url}c=weeklyreport&a=sendReport{/devblocks_url}" method="post">
    <table class="update_table">
        <tr>
            <td  style="width:50%" valign="top">
                <h2>Goals for this week</h2>
                    <div class="container">
                        <textarea class="disabled">{$worker_settings.currentgoals}</textarea>
                    </div>
            </td>
            
            <td style="width:50%" valign="top">
                <h2>Goals for next week</h2>
                    <div class="container">
                        {if !$otherworker}<textarea id="nextgoals" name="nextgoals">{else}<pre>{/if}{$worker_settings.nextgoals}{if !$otherworker}</textarea>{else}</pre>{/if}
                    </div>
            </td>
        </tr>
        
        <tr>
            <td  style="width:50%" valign="top">
                <h2>Accomplishments this week</h2>
                    <div class="container">
                        {if !$otherworker}<textarea id="accomplishments" name="accomplishments">{else}<pre>{/if}{$worker_settings.accomplishments}{if !$otherworker}</textarea>{else}</pre>{/if}
                    </div>
            </td>
            
            <td style="width:50%" valign="top">
                <h2>Concerns</h2>
                    <div class="container">
                        {if !$otherworker}<textarea id="concerns" name="concerns">{else}<pre>{/if}{$worker_settings.concerns}{if !$otherworker}</textarea>{else}</pre>{/if}
                    </div>
            </td>
        </tr>
    </table>
</form>

{if !$otherworker}
    {literal}
    <script type="text/javascript">
        $(function() {
            $('#weekly_report_save').bind('click', function() {
                $('#weekly_report_save').html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/loading.gif{/devblocks_url}{literal}" align="top" /> Saving...');
                $.post('{/literal}{devblocks_url}c=weeklyreport&a=saveReport{/devblocks_url}{literal}',
                    $('#weekly_report_form').serialize(),
                    function(out) {
                        $('#weekly_report_save').html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/save.png{/devblocks_url}{literal}" align="top" /> Report saved');
                        
                        setTimeout (
                            function () {
                                $('#weekly_report_save').html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/save.png{/devblocks_url}{literal}" align="top" /> Save report');
                            }, 2000
                        );
                    },
                    'html'
                );
            });
            
            $('#weekly_report_send').bind('click', function() {
                // check if there are tasks with errors
                var tasks_errors = $('.red.task').length;
                if (tasks_errors == 1) {
                    alert('One of your tasks is not valid');
                    return;
                } else if (tasks_errors > 1) {
                    alert(tasks_errors + ' of your tasks are not valid');
                    return;
                }
                
                
                // check if there are customers with errors
                
                var customers_tasks = $('.red.customer').length;
                if (customers_tasks == 1) {
                    alert('One of your customers is not valid');
                    return;
                } else if (customers_tasks > 1) {
                    alert(customers_tasks + ' of your customers are not valid');
                    return;
                }
                
                
                // check if the user has written everything needed
                
                var accomplishments = $('#accomplishments');
                if (!accomplishments.val()) {
                    alert ('You must write your accomplishments in order to send out the report');
                    accomplishments.focus();
                    return;
                }
                
                var nextgoals = $('#nextgoals');
                if (!nextgoals.val()) {
                    alert ('You must write your goals for next week in order to send out the report');
                    nextgoals.focus();
                    return;
                }
                
                var concerns = $('#concerns');
                if (!concerns.val()) {
                    alert ('You must write your concerns in order to send out the report');
                    concerns.focus();
                    return;
                }
                
                $('#weekly_report_send').html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/loading.gif{/devblocks_url}{literal}" align="top" /> Sending...');
                
                $.post('{/literal}{devblocks_url}c=weeklyreport&a=sendReport{/devblocks_url}{literal}',
                    $('#weekly_report_form').serialize(),
                    function(out) {
                        $('#weeklyreport').html(out);
                    },
                    'html'
                );
            });
        });
    </script>
    {/literal}
{/if}
