<!-- page specific plugin scripts -->
<script src="./assets/js/fuelux/fuelux.tree-custom.js"></script>

<script type="text/javascript">
	var ns_sys_resource = {};
	
	ns_sys_resource.remoteDateSource = function(options, callback) {
		var parent_id = null
		if( !('text' in options || 'type' in options) ){
			parent_id = 0;//load first level data
		}
		else if('type' in options && options['type'] == 'folder') {//it has children
			if('additionalParameters' in options && 'children' in options.additionalParameters)
				parent_id = options.additionalParameters['id'];
		}
		
		if(parent_id !== null) {
			$.ajax({
				url: sys.basePath + "/sys_resource/get-tree-data.do",
				//url: "http://ace.www.dev/examples/treeview.php",
				data: 'parentId='+parent_id,
				type: 'POST',
				dataType: 'json',
				success : function(response) {
					if(response.status == "OK")
						callback({ data: response.data })
				},
				error: function(response) {
					console.error(response);
				}
			})
		}
	};
	
	ns_sys_resource.add = function() {
		var selected = $('#sys_resource-tree').tree('selectedItems');
		if (selected.length>0)
			sys.goInTab('sys_resource_index', sys.basePath + '/sys_resource/edit.do?isAdd=true&id=' + selected[0].additionalParameters.id, '添加资源');
		else
			sys.goInTab('sys_resource_index', sys.basePath + '/sys_resource/edit.do?isAdd=true', '添加资源');
	};
	
	ns_sys_resource.edit = function() {
		var selected = $('#sys_resource-tree').tree('selectedItems');
		if (!selected.length>0)
			return;
		
		sys.goInTab('sys_resource_index', sys.basePath + '/sys_resource/edit.do?isAdd=false&id=' + selected[0].additionalParameters.id, '编辑资源');	
	};
	
	ns_sys_resource.show = function() {
		var selected = $('#sys_resource-tree').tree('selectedItems');
		if (!selected.length>0)
			return;
		
		var viewDialog = new BootstrapDialog({
			draggable: true,
        	closable: true,
        	closeByBackdrop: false,
            closeByKeyboard: false,
            title: '查看详情',
            message: $('<div></div>').load(sys.basePath + '/sys_resource/show.do?id=' + selected[0].additionalParameters.id),
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
	
	ns_sys_resource.delSelected = function() {
		var selected = $('#sys_resource-tree').tree('selectedItems');
		if (!selected.length>0)
			return;
		
		if (selected[0]['type']=='folder') {
			sys.alertInfo('请先删除子菜单', 'info');
			return;
		}
		var id = selected[0].additionalParameters.id;
		var parentId = selected[0].additionalParameters.parentId;
		
		sys.confirm('警告', '确定删除所选数据？', function(dialogRef){
			$.ajax({
	    		url: sys.basePath + "/sys_resource/del.do",
				type: "POST",
				dataType: "json",
				data: 'id=' + id,
				success:function(response, st, xhr) {
					if(typeof(response.success)=="undefined"){
						console.erro("无结果返回/登录超时或未登录");
						sys.alertInfo("无结果返回/登录超时或未登录", "warning");
						return;
					}
					if (response.success == true) {
						dialogRef.close();
						sys.alertInfo(response.msg, "success");
						// refresh folder
						$('#sys_resource-tree').tree('refreshFolder', '#sys_resource-tree_' + parentId);
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
	
	jQuery(function($) {
		$('#sys_resource-tree').tree({ // ace_tree is only a creation wrapper around <ul>! Not using wrapper because branch seleted icon state change
			'dataSource': ns_sys_resource.remoteDateSource, //dataSource1,
			'multiSelect': false,
			'selectable': true,
			'cacheItems': false,
			'open-icon' : 'ace-icon tree-minus',
			'close-icon' : 'ace-icon tree-plus',
			'selected-icon' : 'ace-icon fa fa-check',
			'unselected-icon' : 'ace-icon fa fa-times'
		});
		
		$('#sys_resource-tree').one('loaded.fu.tree', function (event, data) {
			$('#sys_resource-tree').tree('discloseAll');
		});
	});
</script>

<div class="clearfix">
	<div class="col-sm-12">
		<!-- div.treeview_borderWrap -->
		<div class="widget-header">
			<span class="widget-title">
				<#if SecurityUtils.hasPermission('SYS_RESOURCE_ADD')>
		       	<button class="btn btn-sm btn-info" onclick="javascript:ns_sys_resource.add();">
		       		<i class="fa fa-plus-square"></i>&nbsp;&nbsp;添加</button>
		       	</#if>
		       	<#if SecurityUtils.hasPermission('SYS_RESOURCE_VIEW')>
		       	<button class="btn btn-sm btn-info" onclick="javascript:ns_sys_resource.show();">
		       		<i class="fa fa-search-plus"></i>&nbsp;&nbsp;查看</button>
		       	</#if>
		       	<#if SecurityUtils.hasPermission('SYS_RESOURCE_MODIFY')>
		       	<button class="btn btn-sm btn-info" onclick="javascript:ns_sys_resource.edit();">
		       		<i class="fa fa-pencil-square-o"></i>&nbsp;&nbsp;编辑</button>
		       	</#if>
		       	<#if SecurityUtils.hasPermission('SYS_RESOURCE_DEL')>
				<button class="btn btn-sm btn-danger" onclick="javascript:ns_sys_resource.delSelected();">
					<i class="fa fa-trash"></i>&nbsp;&nbsp;删除</button>
				</#if>
		  	</span>
		</div>
		<div class="widget-body">
			<div class="widget-main">
				<ul class="tree" role="tree" id="sys_resource-tree">
					<li class="tree-branch hide" data-template="treebranch" role="treeitem" aria-expanded="false">
						<div class="tree-branch-header">
							<span class="tree-branch-name">
								<i class="icon-folder ace-icon tree-plus"></i>
								<i class="icon-item ace-icon fa fa-times"></i>
								<span class="tree-label"></span>
							</span>
						</div>
						<ul class="tree-branch-children" role="group"></ul>
						<div class="tree-loader" role="alert"><div class="tree-loading"><i class="ace-icon fa fa-refresh fa-spin blue"></i></div></div>
					</li>
					<li class="tree-item hide" data-template="treeitem" role="treeitem">
						<span class="tree-item-name">
						  <i class="icon-item ace-icon fa fa-times"></i>
						  <span class="tree-label"></span>
						</span>
					</li>
				</ul>
				
			</div>
		</div>
	</div>
	<!-- // div.treeview_borderWrap -->
</div>
