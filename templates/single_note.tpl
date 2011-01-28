{assign var=address_id value=$note->address_id}
        
<tr>
    <td class="single-note-date">
        <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/calendar.png{/devblocks_url}" style="vertical-align: text-bottom" />
        {$note->created|date_format}
    </td>
    
    <td class="single-note-worker">
        {if $note->created > $last_update_time}
            <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/comment_new.png{/devblocks_url}" style="vertical-align: text-bottom" alt="this comment is new" title="this comment is new">
        {else}
            <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/comment_old.png{/devblocks_url}" style="vertical-align: text-bottom" alt="this comment is old" title="this comment is old">
        {/if}
        {if isset($workers.$address_id)}<strong>Author</strong>: {$workers.$address_id->getName()}{/if}
    </td>
    
    <td class="single-note-comment">
        <div class="{$type}_note_text">{$note->comment|markdown}</div>
    </td>
    
    <td class="single-note-delete">
        {if !$otherworker}
            <button type="button" id="{$type}_comment_delete_{$note->id}" class="{$type}_comment_delete">
                <img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/delete.png{/devblocks_url}" style="vertical-align: top" />
                delete comment
            </button>
        {/if}
    </td>
</tr>