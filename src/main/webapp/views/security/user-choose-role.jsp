<script type="text/javascript">
	var ns_user_role = {};
	
	ns_user_role.currentRoleIds = {
	                               <#list roles as role>
	                               '${role.roleId}':${role.roleId},
	                               </#list>
	};
	
	ns_user_role.save = function() {
		sys.confirm('保存', '确定保存用户的角色？', function(dialogRef) {
			
			var granted=[];
			var selected = $('#user_role-table').DataTable().rows('.success').data();
			
			$.each(selected, function (index, value) {
				granted.push(value.id);
			});
			
			$.ajax({
	    		url: sys.basePath + "/sys_user/save-roles.do?id=" + '${user.id}',
				type: "POST",
				dataType: "json",
				data: 'array=' + JSON.stringify(granted),
				success:function(response, st, xhr) {
					if(typeof(response.success)=="undefined"){
						console.erro("无结果返回/登录超时或未登录");
						sys.alertInfo("无结果返回/登录超时或未登录", "warning");
						return;
					}
					if (response.success == true) {
						dialogRef.close();
						sys.alertInfo(response.msg, "success");
						sys.backInTab('sys_user_index');
					}else {
						console.error(response.msg);
						sys.alertInfo(response.msg, "warning");
					}
				},
				error:function(xhr,type,msg){
					console.error(msg);
					sys.alertInfo(response.msg, "danger");
				}
	    	});
		});
	};

	ns_user_role.back = function() {
		sys.backInTab('sys_user_index');
	};
	
	jQuery(function($) {
		//initiate dataTables plugin
		ns_user_role.oTable = 
		$('#user_role-table')
		//.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
		.DataTable( {
			serverSide: true,
			ajax: sys.basePath + '/role/list.do',
			columns: [
						{"name": "id", "data": "id", render: function ( data, type, row ) {
						    if ( type === 'display' ) {
						        return "<label class=\"pos-rel\"> <input\
						        type=\"checkbox\" class=\"ace\" /> <span class=\"lbl\"></span>\
						        </label>";
						    }
						    return data;
						}},
			            {"name": "title", "data": "title", "type": "html" },
			            {"name": "code", "data": "code", "visible": false },
			            {"name": "description", "data": "description", "visible": false },
			            {"name": "status", "data": "status",render: function ( data, type, row ) {
			            	if (data)
			            		return "正常";
			            	else return "禁用";
			            	}
			            },
			            {"name": "createTime", "data": "createTime", "type": "date", "visible": false },
			            {"name": "updateTime", "data": "updateTime", "type": "date" },
			            {"name": "updateBy", "data": "updatedBy", "visible": false }
			        ],
			bAutoWidth: false,
	          "aLengthMenu": [
	          [1, 10, 50, 100,500, -1],
	          [1, 10, 50, 100,500, "All"]
	          ],
	        "iDisplayLength" : 10,
			"aaSorting": [],
			"columnDefs": [ {
			      "targets": 0,
			      "searchable": false,
			      "sortable": false
			    },{
				      "targets": 1,
				      "searchable": false,
				      "sortable": false
				},{
			      "targets": 4,
			      "searchable": false,
			      "sortable": false
			    },{
			      "targets": 5,
			      "searchable": false,
			    } ],
			//,
			//"sScrollY": "200px",
			//"bPaginate": false,
	
			//"sScrollX": "100%",
			//"sScrollXInner": "120%",
			//"bScrollCollapse": true,
			//Note: if you are applying horizontal scrolling (sScrollX) on a ".table-bordered"
			//you may want to wrap the table inside a "div.dataTables_borderWrap" element
	
			language: {
				"url": "./assets/js/jquery-datatable-zh-CN.json"
			}
	    } );
	
		//TableTools settings
		TableTools.classes.container = "btn-group btn-overlap";
		TableTools.classes.print = {
			"body": "DTTT_Print",
			"info": "tableTools-alert gritter-item-wrapper gritter-info gritter-center white",
			"message": "打印"
		}
	
		//initiate TableTools extension
		var tableTools_obj = new $.fn.dataTable.TableTools( ns_user_role.oTable, {
			"sSwfPath": "./assets/js/dataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf", //in Ace demo ../assets will be replaced by correct assets path
			
			"sRowSelector": "td",
			"sRowSelect": "multi",
			"fnRowSelected": function(row) {
				//check checkbox when row is selected
				try { $(row).find('input[type=checkbox]').get(0).checked = true }
				catch(e) {}
			},
			"fnRowDeselected": function(row) {
				//uncheck checkbox
				try { $(row).find('input[type=checkbox]').get(0).checked = false }
				catch(e) {}
			},
	
			"sSelectedClass": "success", // selected class!!!
	        "aButtons": [
				{
					"sExtends": "copy",
					"sToolTip": "复制",
					"sButtonClass": "btn btn-white btn-primary btn-bold",
					"sButtonText": "<i class='fa fa-copy bigger-110 pink'></i>",
					"fnComplete": function() {
						this.fnInfo( '<h3 class="no-margin-top smaller">复制成功!</h3>\
							<p>复制了'+(ns_user_role.oTable.fnSettings().fnRecordsTotal())+'行.</p>',
							1500
						);
					}
				},
				
				{
					"sExtends": "csv",
					"sToolTip": "导出csv",
					"sButtonClass": "btn btn-white btn-primary  btn-bold",
					"sButtonText": "<i class='fa fa-file-excel-o bigger-110 green'></i>"
				},
				
				{
					"sExtends": "pdf",
					"sToolTip": "导出PDF",
					"sButtonClass": "btn btn-white btn-primary  btn-bold",
					"sButtonText": "<i class='fa fa-file-pdf-o bigger-110 red'></i>"
				},
				
				{
					"sExtends": "print",
					"sToolTip": "打印",
					"sButtonClass": "btn btn-white btn-primary  btn-bold",
					"sButtonText": "<i class='fa fa-print bigger-110 grey'></i>",
					
					"sMessage": "<div class='navbar navbar-default'><div class='navbar-header pull-left'><a class='navbar-brand' href='#'><small>Optional Navbar &amp; Text</small></a></div></div>",
					
					"sInfo": "<h3 class='no-margin-top'>打印视图</h3><p>请使用浏览器的打印功能来打印本表格.<br />完成后按<b>escape</b>键返回.</p>",
				}
	        ]
	    } );
		//we put a container before our table and append TableTools element to it
	    $(tableTools_obj.fnContainer()).appendTo($('#user_role_tableTools-container'));
		
		//also add tooltips to table tools buttons
		//addding tooltips directly to "A" buttons results in buttons disappearing (weired! don't know why!)
		//so we add tooltips to the "DIV" child after it becomes inserted
		//flash objects inside table tools buttons are inserted with some delay (100ms) (for some reason)
		setTimeout(function() {
			$(tableTools_obj.fnContainer()).find('a.DTTT_button').each(function() {
				var div = $(this).find('> div');
				if(div.length > 0) div.tooltip({container: 'body'});
				else $(this).tooltip({container: 'body'});
			});
		}, 200);
		
		
		
		//ColVis extension
		var colvis = new $.fn.dataTable.ColVis( ns_user_role.oTable, {
			"buttonText": "<i class='fa fa-search'></i>",
			"aiExclude": [0, 6],
			"bShowAll": true,
			//"bRestore": true,
			"sAlign": "right",
			"fnLabel": function(i, title, th) {
				return $(th).text();//remove icons, etc
			}
		}); 
		
		//style it
		$(colvis.button()).addClass('btn-group').find('button').addClass('btn btn-white btn-info btn-bold')
		
		//and append it to our table tools btn-group, also add tooltip
		$(colvis.button())
		.prependTo('#user_role_tableTools-container .btn-group')
		.attr('title', '选择列').tooltip({container: 'body'});
		
		//and make the list, buttons and checkboxed Ace-like
		$(colvis.dom.collection)
		.addClass('dropdown-menu dropdown-light dropdown-caret dropdown-caret-right')
		.find('li').wrapInner('<a href="javascript:void(0)" />') //'A' tag is required for better styling
		.find('input[type=checkbox]').addClass('ace').next().addClass('lbl padding-8');
	
	
		
		/////////////////////////////////
		//table checkboxes
		$('th input[type=checkbox], td input[type=checkbox]').prop('checked', false);
		
		//select/deselect all rows according to table header checkbox
		$('#user_role-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
			var th_checked = this.checked;//checkbox inside "TH" table header
			
			$(this).closest('table').find('tbody > tr').each(function(){
				var row = this;
				if(th_checked) tableTools_obj.fnSelect(row);
				else tableTools_obj.fnDeselect(row);
			});
		});
		
		//select/deselect a row when the checkbox is checked/unchecked
		$('#user_role-table').on('click', 'td input[type=checkbox]' , function(){
			var row = $(this).closest('tr').get(0);
			if(!this.checked) tableTools_obj.fnSelect(row);
			else tableTools_obj.fnDeselect($(this).closest('tr').get(0));
		});
		
		$('#user_role-table').DataTable().on('draw.dt', function () {
		    $('#user_role-table').find('tbody > tr').each(function(){
				var row = this;
				
				var data = $('#user_role-table').DataTable().row(row).data();
				if (ns_user_role.currentRoleIds[data.id]) {
					tableTools_obj.fnSelect(row);
				}
			});
		} );
	});
</script>


<div class="clearfix">
	<div class="pull-left">
       	<button class="btn btn-sm btn-info" onclick="javascript:ns_user_role.save();">
       		<i class="fa fa-floppy-o"></i>&nbsp;&nbsp;保存</button>
		<button class="btn btn-sm btn-default" onclick="javascript:ns_user_role.back();">
			<i class="fa fa-reply"></i>&nbsp;&nbsp;返回</button>
		<span>当前用户：${user.username}</span>
  	</div>
	<div class="pull-right tableTools-container" id="user_role_tableTools-container">
	</div>
</div>
<!-- div.dataTables_borderWrap -->
<div>
	<table id="user_role-table"
		class="table table-striped table-bordered table-hover">
		<thead>
			<tr>
				<th><label class="pos-rel"> <input
						type="checkbox" class="ace" /> <span class="lbl"></span>
				</label></th>
				<th>名称</th>
				<th>编码</th>
				<th class="hidden-480">描述</th>
				<th>状态</th>
				<th><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i>创建时间</th>
				<th><i class="ace-icon fa fa-clock-o bigger-110 hidden-480"></i>更新时间</th>
				<th>更新人</th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</div>
<!-- // div.dataTables_borderWrap -->