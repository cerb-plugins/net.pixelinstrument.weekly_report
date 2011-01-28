{if sizeof($customers)}
    <h2>Customers Update</h2>
    <table class="update_table">
        <tr><td style="height: 5px"></td></tr>
        
        {foreach from=$customers key=c_id item=customer}
            {assign var="customer_problems" value=1}
            {foreach from=$customer.c_notes item="note"}
                {if $note->created > $last_update_time && $note->address_id == $active_worker_address_id}
                    {assign var="customer_problems" value=0}
                {/if}
            {/foreach}
            <tr class="customer {if $customer_problems}red{else}green{/if}">
                <td class="left">
                    <a id="customer_link_{$c_id}" class="strong big customer_link" href="javascript:;">{$customer.c_name}</a>
                
                    {if sizeof($customer.c_workers)}
                        <div class="owner">
                            <strong>Workers</strong>:
                            
                            {foreach from=$customer.c_workers item=worker name=customer_workers}
                                {$worker->getName()}{if !$smarty.foreach.customer_workers.last}, {/if}
                            {/foreach}
                        </div>
                    {/if}
                </td>
            </tr>
            
            {if $customer_problems}
                {assign var=class value='rowred'}
            {else}
                {assign var=class value='rowgreen'}
            {/if}
            
            <tr class="{$class}">
            	<td>
                    <table class="single-note">
                        {assign var=last_note_created value=-1}
                        {foreach from=$customer.c_notes item="note"}
                            {include file="devblocks:net.pixelinstrument.weekly_report::single_note.tpl" class=$class type='customer' note=$note}
                        {/foreach}
                        
                        {if !$otherworker}
                            <tr>
                                <td class="single-note-date">
                                    <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/calendar.png{/devblocks_url}" style="vertical-align: text-bottom" />
                                    {time()|date_format}
                                </td>
                                
                                <td class="single-note-worker">
                                    <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/comment_write.png{/devblocks_url}" style="vertical-align: text-bottom" alt="add a new comment" title="add a new comment">
                                    <strong>Author</strong>: {$active_worker->getName()}
                                </td>
                                
                                <td class="single-note-comment">
                                    <textarea id="customer_comment_{$c_id}" name="comment" class="comment"></textarea>
                                </td>
                                
                                <td class="single-note-delete">
                                    <button type="button" id="customer_comment_button_{$c_id}" class="customer_comment_button"><img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/add_comment.png{/devblocks_url}" align="top"> add comment</button>
                                </td>
                            </tr>
                        {/if}
                    </table>
                </td>
            </tr>
            
            <tr class="{if $customer_problems}lastrowred{else}lastrowgreen{/if}">
                <td></td>
            </tr>
        {/foreach}
    </table>
    
    {if !$otherworker}
        {literal}
        <script type="text/javascript">
            function reloadCustomers() {
                $.get('{/literal}{devblocks_url}c=weeklyreport&a=reloadCustomers{/devblocks_url}{literal}',
                    null,
                    function(out) {
                        $("#customers_list").html(out);
                    },
                    'html'
                );    
            }
            
            $(function() {
                // assign function to call when a customer name is clicked
                
                $('.customer_link').bind('click', function() {
                    var c_id = this.id.match(/^customer_link_([0-9]+)$/);
                    if (c_id) {
                        $popup = genericAjaxPopup('peek','c=contacts&a=showOrgPeek&id='+c_id[1],null,false,'550');
                        $popup.one('org_save', function(event) {
                            event.stopPropagation();
                            reloadCustomers();
                        });
                    }
                });
                
                
                // assign a function to call when the add comment button is called
                $('.customer_comment_button').bind('click', function() {
                    $(this).html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/loading.gif{/devblocks_url}{literal}" align="top"> adding comment');
                    var c_id = this.id.match(/^customer_comment_button_([0-9]+)$/);
                    if (c_id) {
                        var comment = $('#customer_comment_'+c_id[1]);
                        if (comment) {
                            $.post('{/literal}{devblocks_url}c=weeklyreport&a=addCustomerComment{/devblocks_url}{literal}',
                                $.param(comment, true) + '&id=' + c_id[1],
                                function(out) {
                                    reloadCustomers();    
                                },
                                'html'
                            );
                        }
                    }
                });
                
                
                // assign a function to call when the delete comment is clicked
                $('.customer_comment_delete').bind('click', function() {
                    if (confirm('Are you sure you want to delete this comment?')) {
                        $(this).html('<img src="{/literal}{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/loading.gif{/devblocks_url}{literal}" align="top"> deleting comment');
                        var c_id = this.id.match(/^customer_comment_delete_([0-9]+)$/);
                        if (c_id) {
                            $.post('{/literal}{devblocks_url}c=weeklyreport&a=deleteComment{/devblocks_url}{literal}',
                                'id=' + c_id[1],
                                function(out) {
                                    reloadCustomers();    
                                },
                                'html'
                            );
                        }
                    }
                });
            });
        </script>
        {/literal}
    {/if}
{/if}