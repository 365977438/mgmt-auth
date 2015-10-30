<script type="text/javascript">
	var ns_role = {};

	ns_role.viewDetail = function(id) {
		var viewDialog = new BootstrapDialog({
			draggable: true,
        	closable: true,
        	closeByBackdrop: false,
            closeByKeyboard: false,
            title: '查看详情',
            message: $('<div></div>').load(sys.basePath + '/role/show.do?id=' + id),
            buttons: [{
                label: '关闭',
                cssClass: 'btn-primary',
                action: function(dialogItself) {
                    dialogItself.close();
                }
            }]
        });
		viewDialog.open();
	};
	
	ns_role.add = function(id) {
		sys.goInTab('role_index', sys.basePath + '/role/edit.do', '添加角色');
	};

	ns_role.edit = function(id) {
		sys.goInTab('role_index', sys.basePath + '/role/edit.do?id=' + id, '编辑角色');
	};
	
	ns_role.authorize = function(id) {
		sys.goInTab('role_index', sys.basePath + '/role/authorize.do?id=' + id, '角色授权');
	};
	
	ns_role.del = function(id) {
		var delConfirmDialog = new BootstrapDialog({
        	closable: true,
        	title: '警告',
            message: '确定删除此数据？',
            buttons: 
            	[
				  {
				    label: '确定',
				    cssClass: 'btn-danger',
				    action: function(dialogRef) {
				    	$.ajax({
				    		url: sys.basePath + "/role/del.do",
							type: "POST",
							dataType: "json",
        					data: {"array": JSON.stringify([id])},
							success:function(response, st, xhr) {
								if(typeof(response.success)=="undefined"){
									console.erro("无结果返回/登录超时或未登录");
									sys.alertInfo("无结果返回/登录超时或未登录", "warning");
									return;
								}
								if (response.success == true) {
									dialogRef.close();
									sys.alertInfo(response.msg, "success");
									ns_role.oTable.ajax.reload();
								}else {
									console.error(response.msg);
									sys.alertInfo(response.msg, "warning");
								}
							},
							error:function(xhr,type,msg){
								console.error(msg);
								sys.alertInfo(msg, "danger");
							}
				    	});
				    }
				 },
            	 {
            		label:'取消',
            		cssClass: 'btn-default',
            		action: function(dialogRef) {
            			dialogRef.close();
            		}
            	 }
	           ]
        });
		delConfirmDialog.open();
	};
	
	ns_role.delSelected = function() {
		var idArray = [];
		var table = $('#role-table').DataTable();
		for (var i=0; i<table.rows('.success').data().length;i++) {
			idArray.push(table.rows('.success').data()[i]['id']);
		}
		
		if(idArray.length == 0) {
			sys.alertInfo("请选择数据！","info");
			return false;
		}
		
		var delConfirmDialog = new BootstrapDialog({
        	closable: true,
        	title: '警告',
            message: '确定删除所选数据？',
            buttons: 
            	[
				  {
				    label: '确定',
				    cssClass: 'btn-danger',
				    action: function(dialogRef) {
				    	
							$.ajax({
								url: sys.basePath + "department/del.do",
								type: "POST",
								dataType: "json",
								data: {"array": JSON.stringify(idArray)},
								success:function(response,st, xhr) {
									if(typeof(response.success)=="undefined"){
										console.erro("无结果返回/登录超时或未登录");
										sys.alertInfo("无结果返回/登录超时或未登录", "warning");
										return;
									}
									if (response.success == true) {
										dialogRef.close();
										sys.alertInfo(response.msg, "warning");
										ns_role.oTable.ajax.reload();
									}else {
										console.error(response.msg);
									}
								},
								error:function(xhr,type,msg){
									console.error(msg);
									sys.alertInfo(msg, "danger");
								}
							});
						}
				 },
            	 {
            		label:'取消',
            		cssClass: 'btn-default',
            		action: function(dialogRef) {
            			dialogRef.close();
            		}
            	 }
	           ]
        });
		delConfirmDialog.open();
	};
	
	jQuery(function($) {
		//initiate dataTables plugin
		ns_role.oTable = 
		$('#role-table')
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
						 {"name": "operation", "data": "id", render: function ( data, type, row ) {
							    if ( type === 'display' ) {
							        var html= '<div class="hidden-sm hidden-xs action-buttons">';
							        <#if SecurityUtils.hasPermission('SYS_ROLE_VIEW')>
										html += '<a class="blue" title="查看" href="javascript:ns_role.viewDetail(' + data + ');">\
											<i class="ace-icon fa fa-search-plus bigger-130"></i>\
										</a>';
									</#if>
									<#if SecurityUtils.hasPermission('SYS_ROLE_EDIT')>
										html += '<a class="green" title="编辑" href="javascript:ns_role.edit(' + data + ');">\
											<i class="ace-icon fa fa-pencil bigger-130"></i>\
										</a>';
										</#if>
									<#if SecurityUtils.hasPermission('SYS_ROLE_DEL')>
										html+= '<a class="red" title="删除" href="javascript:ns_role.del(' + data + ');">\
											<i class="ace-icon fa fa-trash-o bigger-130"></i>\
										</a>';
									</#if>
									<#if SecurityUtils.hasPermission('SYS_ROLE_AUTH')>
										html+= '<a class="blue" title="角色权限" href="javascript:ns_role.authorize(' + data + ');">\
											<i class="ace-icon fa fa-eye bigger-130"></i>\
										</a>';
									</#if>
									html += '</div>\
									<div class="hidden-md hidden-lg">\
										<div class="inline pos-rel">\
											<ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">';
												<#if SecurityUtils.hasPermission('SYS_ROLE_VIEW')>
												html += '<li>\
													<a title="查看" href="javascript:ns_role.viewDetail(' + data + ');" class="tooltip-info" data-rel="tooltip" title="View">\
														<span class="blue">\
															<i class="ace-icon fa search-plus bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												</#if>
												<#if SecurityUtils.hasPermission('SYS_ROLE_EDIT')>
												html += '<li>\
													<a title="编辑" href="javascript:ns_role.edit(' + data + '); class="tooltip-success" data-rel="tooltip" title="Edit">\
														<span class="green">\
															<i class="ace-icon fa fa-pencil-square-o bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												</#if>
												<#if SecurityUtils.hasPermission('SYS_ROLE_DEL')>
												html += '<li>\
													<a title="删除" href="javascript:ns_role.del(' + data + ');" class="tooltip-error" data-rel="tooltip" title="Delete">\
														<span class="red">\
															<i class="ace-icon fa fa-trash-o bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												</#if>
												<#if SecurityUtils.hasPermission('SYS_ROLE_AUTH')>
												html += '<li>\
													<a title="角色权限" href="javascript:ns_role.authorize(' + data + ');" class="tooltip-error" data-rel="tooltip" title="Delete">\
														<span class="red">\
															<i class="ace-icon fa fa-eye bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												</#if>
											html += '</ul>\
										</div>\
									</div>';
									return html;
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
		var tableTools_obj = new $.fn.dataTable.TableTools( ns_role.oTable, {
			"sSwfPath": "./assets/js/dataTables/extensions/TableTools/swf/copy_csv_xls_pdf.swf", //in Ace demo ../assets will be replaced by correct assets path
			
			"sRowSelector": "td:not(:nth-child(2))", // starting with 1
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
							<p>复制了'+(ns_role.oTable.fnSettings().fnRecordsTotal())+'行.</p>',
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
	    $(tableTools_obj.fnContainer()).appendTo($('#role_tableTools-container'));
		
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
		var colvis = new $.fn.dataTable.ColVis( ns_role.oTable, {
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
		.prependTo('#role_tableTools-container .btn-group')
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
		$('#role-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
			var th_checked = this.checked;//checkbox inside "TH" table header
			
			$(this).closest('table').find('tbody > tr').each(function(){
				var row = this;
				if(th_checked) tableTools_obj.fnSelect(row);
				else tableTools_obj.fnDeselect(row);
			});
		});
		
		//select/deselect a row when the checkbox is checked/unchecked
		$('#role-table').on('click', 'td input[type=checkbox]' , function(){
			var row = $(this).closest('tr').get(0);
			if(!this.checked) tableTools_obj.fnSelect(row);
			else tableTools_obj.fnDeselect($(this).closest('tr').get(0));
		});
	});
</script>


<div class="clearfix">
	<div class="pull-left">
		<#if SecurityUtils.hasPermission('SYS_ROLE_ADD')>
       	<button class="delete btn btn-sm btn-info" onclick="javascript:ns_role.add();">
       		<i class="fa fa-plus-square"></i>&nbsp;&nbsp;添加</button>
       	</#if>
       	<#if SecurityUtils.hasPermission('SYS_ROLE_DEL')>
		<button class="delete btn btn-sm btn-danger" onclick="javascript:ns_role.delSelected();">
			<i class="fa fa-trash"></i>&nbsp;&nbsp;删除</button>
		</#if>
  	</div>
	<div class="pull-right tableTools-container" id="role_tableTools-container">
	</div>
</div>
<!-- div.dataTables_borderWrap -->
<div>
	<table id="role-table"
		class="table table-striped table-bordered table-hover">
		<thead>
			<tr>
				<th><label class="pos-rel"> <input
						type="checkbox" class="ace" /> <span class="lbl"></span>
				</label></th>
				<th>操作</th>
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