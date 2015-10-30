<script type="text/javascript">
	var ns_user = {};
	
	<#if SecurityUtils.hasPermission('SYS_USER_VIEW')>
	// 不显示相关javascript，较安全，也可不控制
	ns_user.viewDetail = function(id) {
		var viewDialog = new BootstrapDialog({
			draggable: true,
        	closable: true,
        	closeByBackdrop: false,
            closeByKeyboard: false,
            title: '查看详情',
            message: $('<div></div>').load(sys.basePath + '/sys_user/show.do?id=' + id),
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
	</#if>
	
	<#if SecurityUtils.hasPermission('SYS_USER_ADD')>
	ns_user.add = function(id) {
		sys.goInTab('sys_user_index', sys.basePath + '/sys_user/edit.do', '添加用户');
	};
	</#if>
	
	<#if SecurityUtils.hasPermission('SYS_USER_EDIT')>
	ns_user.edit = function(id) {
		sys.goInTab('sys_user_index', sys.basePath + '/sys_user/edit.do?id=' + id, '编辑用户');
	};
	</#if>
	
	<#if SecurityUtils.hasPermission('SYS_USER_GRANT')>
	ns_user.chooseRole = function(id) {
		sys.goInTab('sys_user_index', sys.basePath + '/sys_user/choose-role.do?id=' + id, '选择角色');
	};
	</#if>
	
	<#if SecurityUtils.hasPermission('SYS_USER_DEL')>
	ns_user.del = function(id) {
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
				    		url: sys.basePath + "/sys_user/del.do",
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
									ns_user.oTable.ajax.reload();
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
	
	ns_user.delSelected = function() {
		var idArray = [];
		var table = $('#user-table').DataTable();
		for (var i=0; i<table.rows('.success').data().length;i++) {
			console.dir(table.rows('.success').data()[i]);
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
								url: sys.basePath + "/sys_user/del.do",
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
										ns_user.oTable.ajax.reload();
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
	</#if>
	
	ns_user.deptList = $.parseJSON('${(deptOptions)!}');
	
	jQuery(function($) {
		//initiate dataTables plugin
		ns_user.oTable = 
		$('#user-table')
		//.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
		.DataTable( {
			serverSide: true,
			ajax: sys.basePath + '/sys_user/list.do',
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
							        if (sys.hasPermission('SYS_USER_VIEW'))
										html += '<a class="blue" href="javascript:ns_user.viewDetail(' + data + ');">\
											<i class="ace-icon fa fa-search-plus bigger-130"></i>\
										</a>';
									if (sys.hasPermission('SYS_USER_EDIT'))
										html += '<a class="green" href="javascript:ns_user.edit(' + data + ');">\
											<i class="ace-icon fa fa-pencil bigger-130"></i>\
										</a>';
									if (sys.hasPermission('SYS_USER_DEL'))
										html += '<a class="red" href="javascript:ns_user.del(' + data + ');">\
											<i class="ace-icon fa fa-trash-o bigger-130"></i>\
										</a>';
									if (sys.hasPermission('SYS_USER_GRANT'))
										html += '<a class="blue" title="选择角色" href="javascript:ns_user.chooseRole(' + data + ');">\
											<i class="ace-icon fa fa-eye bigger-130"></i>\
										</a>';
									html += '</div>\
									<div class="hidden-md hidden-lg">\
										<div class="inline pos-rel">\
											<ul class="dropdown-menu dropdown-only-icon dropdown-yellow dropdown-menu-right dropdown-caret dropdown-close">';
												if (sys.hasPermission('SYS_USER_VIEW'))
													html += '<li>\
													<a href="javascript:ns_user.viewDetail(' + data + ');" class="tooltip-info" data-rel="tooltip" title="View">\
														<span class="blue">\
															<i class="ace-icon fa search-plus bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												if (sys.hasPermission('SYS_USER_EDIT'))
													html += '<li>\
													<a href="javascript:ns_user.edit(' + data + '); class="tooltip-success" data-rel="tooltip" title="Edit">\
														<span class="green">\
															<i class="ace-icon fa fa-pencil-square-o bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												if (sys.hasPermission('SYS_USER_DEL'))
													html += '<li>\
													<a href="javascript:ns_user.del(' + data + ');" class="tooltip-error" data-rel="tooltip" title="Delete">\
														<span class="red">\
															<i class="ace-icon fa fa-trash-o bigger-120"></i>\
														</span>\
													</a>\
												</li>';
												if (sys.hasPermission('SYS_USER_GRANT'))
													html += '<li>\
													<a title="选择角色" href="javascript:ns_user.chooseRole(' + data + ');" class="tooltip-error" data-rel="tooltip" title="Delete">\
														<span class="red">\
															<i class="ace-icon fa fa-eye bigger-120"></i>\
														</span>\
													</a>\
												</li>';
											html += '</ul>\
										</div>\
									</div>';
									return html;
							    }
							    return data;
							}},
			            {"name": "username", "data": "username", "type": "html" },
			            {"name": "fullName", "data": "fullName" },
			            {"name": "mobile", "data": "mobile" },
			            {"name": "email", "data": "email" },
			            {"name": "department", "data": "departmentId", render:function(data, type, row) {
			            	if (ns_user.deptList[data])
			            		return ns_user.deptList[data];
			            	else
			            		return "";
			            }},
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
			    }],
			language: {
				"url": "./assets/js/jquery-datatable-zh-CN.json"
			}
	    });
		<#if SecurityUtils.hasPermission('SYS_USER_LIST')>
		sys.addDatatableTools(2, '#user_tableTools-container', 'ns_user.exportExcel()', '#user-table', ns_user.oTable);
		</#if>
	});
	
	ns_user.exportExcel = function() {
		sys.exportExcel('#user-table', sys.basePath + '/sys_user/exportExcel.do', '用户导出.xls');
	};
</script>


<div class="clearfix">
	<div class="pull-left">
		<#if SecurityUtils.hasPermission('SYS_USER_ADD')>
       	<button class="btn btn-sm btn-info" onclick="javascript:ns_user.add();">
       		<i class="fa fa-plus-square"></i>&nbsp;&nbsp;添加</button>
       	</#if>
       	<#if SecurityUtils.hasPermission('SYS_USER_DEL')>
		<button class="delete btn btn-sm btn-danger" onclick="javascript:ns_user.delSelected();">
			<i class="fa fa-trash"></i>&nbsp;&nbsp;删除</button>
		</#if>
  	</div>
	<div class="pull-right tableTools-container" id="user_tableTools-container">
	</div>
</div>
<!-- div.dataTables_borderWrap -->
<div>
	<table id="user-table"
		class="table table-striped table-bordered table-hover">
		<thead>
			<tr>
				<th><label class="pos-rel"> <input
						type="checkbox" class="ace" /> <span class="lbl"></span>
				</label></th>
				<th>操作</th>
				<th>用户名</th>
				<th>姓名</th>
				<th>手机号码</th>
				<th>邮箱</th>
				<th>部门</th>
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