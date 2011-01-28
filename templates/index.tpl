<style>{literal}
	img {
		border: 0;
	}
	
	div.owner {
		color: #666;
		font-size: 11px;
		margin-left: 20px;
	}
	
	#weeklyreport textarea {
		width: 90%;
		height: 100px;
		border-radius: 10px;
		padding: 5px;
	}
	
	#weeklyreport textarea.disabled {
		background: #e6e6e6;
	}
	
	#weeklyreport tr.row {
		border-left: 1px solid #00C;
		border-right: 1px solid #00C;
		background: #FCFCFF !important;
	}
	
	#weeklyreport tr.rowred {
		border-left: 1px solid #C00;
		border-right: 1px solid #C00;
		background: #FFFCFC !important;
	}
	
	#weeklyreport tr.rowonhold {
		border-left: 1px solid #AAA;
		border-right: 1px solid #AAA;
		background: #FCFCFC !important;
	}
	
	#weeklyreport tr.rowgreen {
		border-left: 1px solid #0C0;
		border-right: 1px solid #0C0;
		background: #FCFFFC !important;
	}
	
	#weeklyreport tr.lastrow {
		border-top: 1px solid #00C;
		height: 25px;
	}
	
	#weeklyreport tr.lastrowred {
		border-top: 1px solid #C00;
		height: 25px;
	}
	
	#weeklyreport tr.lastrowonhold {
		border-top: 1px solid #AAA;
		height: 25px;
	}
	
	#weeklyreport tr.lastrowgreen {
		border-top: 1px solid #0C0;
		height: 25px;
	}
	
	#weeklyreport td {
		padding: 5px;
		vertical-align: top;
	}
	
	#weeklyreport td.date {
		white-space: nowrap;
		width: 20%;
		text-align: center;
		font-weight: bold;
	}
	
	#weeklyreport td.title {
		text-align: left;
		width: 80%;
	}
	
	#weeklyreport td.title strong {
		font-size: 110%;
	}
	
	#weeklyreport td.li {
		white-space: nowrap;
		width: 1px;
	}
	
	.container {
		margin-bottom: 20px;
	}
	
	ul, li {
		margin: 0;
	}
	
	ul {
		padding-left: 20px;
	}
	
	td li {
		list-style-position: outside;
		margin-left: 15px;
	}
	
	.not_updated {
		color: #C00;
	}
	
	td h3 {
		margin: 0;
	}
	
	a.red {
		color: #C00;
		text-decoration: none;
	}
	
	a.red:hover {
		text-decoration: underline;
	}
	
	a.normal {
		text-decoration: none;
	}
	
	a.normal:hover {
		text-decoration: underline;
	}
	
	tr.red td, div.red {
		border: 1px solid #C00 !important;
		background: #FDD !important;
		color: #A00;
	}
	
	tr.red td a {
		color: #A00;
	}
	
	tr.yellow td, div.yellow {
		border: 1px solid #CC0 !important;
		background: #FFD !important;
		color: #A90;
	}
	
	tr.yellow td a {
		color: #A90;
	}
	
	tr.green td, div.green {
		border: 1px solid #0C0 !important;
		background: #DFD !important;
		color: #0A0;
	}
	
	tr.green td a {
		color: #0A0;
	}
    
    span.label {
        padding: 3px 5px 2px 5px;
        border-radius: 8px;
    }
    
    span.red {
        background: #A00;
        color: #FDD;
    }
    
    span.green {
        background: #0A0;
        color: #AFA;
    }
    
    span.yellow {
        background: #CA0;
        color: #EFA;
    }
	
	tr.onhold td, div.onhold {
		background: #F0F0F0 !important;
		border: 1px solid #AAA !important;
		color: #000;
	}
	
	td.red {
		color: #C00 !important;
	}
	
	.strong {
		font-weight: bold;
		text-decoration: none;
	}
	
	.strong:hover {
		text-decoration: underline;
	}
	
	.big {
		font-size: 110%;
	}
	
	.small {
		font-size: 80%;
	}
	
	.left {
		text-align: left !important;
	}
	
	h3.green {
		color: #0A0;
	}
	
	h3.red {
		color: #A00;
	}
	
	h3.yellow {
		color: #AA0;
	}
	
	#adding_comment {
		display: none;
		position: fixed;
		top: 49%;
		padding: 15px;
		width: 15%;
		left: 42%;
		text-align: center;
		font-size: 120%;
		border:1px solid #D90;
		background-color:rgb(255,255,235);
		color:#D90;
		font-weight:bold;
	}
	
	.nolinkcursor a {
		cursor: help !important;
	}
	
	table.update_table {
		width: 100%;
		border-collapse: collapse;
		border-top: 1px solid #AAA;
		margin-bottom: 15px;
	}
	
	table.update_table tr th {
		font-size: 12px;
		text-align: left;
		padding-top: 7px;
	}
	
	tr.task, tr.task td, tr.ticket, tr.ticket td, div.ongoing {
		border: 1px solid #00C;
		background: #DDF;
		text-align: center;
	}
	
	tr.task td, tr.ticket td {
		vertical-align: middle !important;
	}

	.task_note_date, .customer_note_date, .ticket_note_date {
		font-weight: bold;
		padding: 3px;
		text-align: left;
	}
	
	.task_note_worker, .customer_note_worker, .ticket_note_worker {
		font-weight: normal;
		padding: 10px;
		font-size: 12px;
		clear: both;
	}
	
	.task_note_text, .customer_note_text, .ticket_note_text {
		margin-left: 2%;
		border: 1px solid #AAA;
		background: #e6e6e6;
		padding: 5px;
		border-radius: 10px;
		width: 96%;
	}
	
	.task_note_delete, .customer_note_delete, .ticket_note_delete {
		margin-left: 4%;
		padding: 4px;
	}
	
	.task_note_add, .customer_note_add {
		margin-left: 25px;
		font-weight: bold;
	}
	
	.alert {
		background-color: #EBEBFF;
		border: 1px solid #0000B4;
		color: #0000B4;
		font-weight: bold;
		margin: 10px;
		padding: 5px;
		width: 400px;
		text-align: center;
	}
	
	.section {
		border: 1px dotted #666;
		padding: 5px;
		position: relative;
		padding-top: 10px;
		margin-bottom: 12px;
	}
	
	.section h1 {
		font-size: 10pt;
		position: absolute;
		left: 5pt;
		top: -8pt;
		padding: 2px;
		background: #F2F2F2;
	}
	
	#weeklyreport_instructions {
		display: none;
		padding: 10px;
		border: 1px dotted #00C;
		background: #EFEFFF;
		font-size: 90%;
	}

	#weeklyreport_instructions h3 {
		margin: 0;
	}
	
	#weeklyreport_instructions p > h3 {
		margin-bottom: 40px;
	}
	
	div.legenda {
		width: 12px;
		height: 12px;
		border: 1px solid;
		float: left;
		margin-right: 5px;
	}
	
	ul.help {
		list-style-type: none;
	}
	
	ul.help li {
		height: 20px;
	}
	
	table.help {
		border: 1px solid #AAA;
		width: 42%;
		border-collapse: collapse;
	}
	
	table.help th {
		border: 1px solid #AAA;
		text-align: center;
		background: #DDF;
		font-size: 12px;
	}
	
	table.help td {
		border: 1px solid #AAA;
		text-align: center;
	}
	
	#hidden_panels {
		display: none;
	}
	
	.comment {
		margin: 0px;
		margin-left: 2% !important;
		width: 96% !important;
	}
	
	.align-center {
		text-align: center;
	}
	
	#weekly_report_success {
		text-align: center;
		margin-top: 30px;
	}
    
    #weekly_report_failure {
        text-align: center;
		margin-top: 30px;
    }
    
    #weekly_report_failure h1 {
        color: #C00 !important;
    }
	
	#otherworker {
		margin-bottom: 10px;
	}
	
	.single-note {
		width: 100%;
	}
	
	.single-note td {
		white-space: nowrap;
		vertical-align: top;
		border: 0px;
	}
	
	.single-note-date {
		width: 1%;
	}
	
	.single-note-worker {
		white-space: nowrap;
		width: 1%;
	}
	
	.single-note-comment {
		white-space: nowrap;
	}
	
	.single-note-delete {
		white-space: nowrap;
		width: 1%;
		text-align: center;
	}
	
	td.narrow {
		width: 12%;
		white-space: nowrap;
	}
    
    td.normal {
		width: 18%;
		white-space: nowrap;
	}
    
    .center {
        text-align: center;
    }
    
    .customer_type {
        float: left;
        position: absolute;
    }
{/literal}</style>

<ul class="submenu">
</ul>
<div style="clear:both;"></div>

<div id="weeklyreport">
	<h1>{$active_worker->getName()} Weekly Report</h1>
	
	<div id="otherworker">
		{if !$otherworker}
			See other worker's report:
			<select onchange="location.href='{devblocks_url}c=weeklyreport{/devblocks_url}/'+this.value">
				<option value="">--- Select a worker ---</option>
				{foreach from=$workers key=w_id item=worker}
					{if $w_id != $active_worker->id}
						<option value="{$w_id}">{$worker->getName()}</option>
					{/if}
				{/foreach}
			</select>
		{else}
			<button onclick="location.href='{devblocks_url}c=weeklyreport{/devblocks_url}'"><span class="cerb-sprite sprite-nav_down_left_green"></span> back to your report</button>
		{/if}
	</div>

	<div id="tasks_list">
		{include file="devblocks:net.pixelinstrument.weekly_report::tasks.tpl"}
	</div>
	
	<div id="customers_list">
		{include file="devblocks:net.pixelinstrument.weekly_report::customers.tpl"}
	</div>
	
	<div id="tickets_list">
		{include file="devblocks:net.pixelinstrument.weekly_report::tickets.tpl"}
	</div>
	
	<div id="weekly_report">
		{include file="devblocks:net.pixelinstrument.weekly_report::report.tpl"}
	</div>
	
	{if !$otherworker}
		<button type="button" id="weekly_report_send"><img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/check.png{/devblocks_url}" align="top" /> Send report</button>
		<button type="button" id="weekly_report_save"><img src="{devblocks_url}c=resource&p=net.pixelinstrument.weekly_report&f=images/save.png{/devblocks_url}" align="top" /> Save report</button>
	{/if}
</div>
