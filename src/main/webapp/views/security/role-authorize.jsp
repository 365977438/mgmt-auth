<!-- page specific plugin scripts -->
<script src="./assets/js/fuelux/fuelux.tree-custom.js"></script>

<script type="text/javascript">
	var ns_role_authorize = {};
	ns_role_authorize.roleId = ${(model.id)!};
	
	ns_role_authorize.remoteDateSource = function(options, callback) {
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
				url: sys.basePath + "/role/get-tree-data.do",
				data: 'parentId='+parent_id+"&roleId="+ns_role_authorize.roleId,
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
	
	ns_role_authorize.back = function() {
		sys.backInTab('role_index');
	};
	
	ns_role_authorize.save = function() {
		sys.confirm('保存', '确定保存角色的权限？', function(dialogRef) {
			var selected = $('#role_authorize-tree').tree('selectedItems');
			//var allItems = $('#role_authorize-tree').tree('allLoadedItems');
			
			var granted=[];
			$.each(selected, function (index, value) {
				granted.push(value.additionalParameters.id);
			});
			
			$.ajax({
	    		url: sys.basePath + "/role/save-auth.do?id=" + '${model.id}',
				type: "POST",
				dataType: "json",
				data: 'granted=' + JSON.stringify(granted),
				success:function(response, st, xhr) {
					if(typeof(response.success)=="undefined"){
						console.erro("无结果返回/登录超时或未登录");
						sys.alertInfo("无结果返回/登录超时或未登录", "warning");
						return;
					}
					if (response.success == true) {
						dialogRef.close();
						sys.alertInfo(response.msg, "success");
						sys.backInTab('role_index');
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
		});
	};
	
	jQuery(function($) {
		$('#role_authorize-tree').tree({ // ace_tree is only a creation wrapper!
			'dataSource': ns_role_authorize.remoteDateSource, //dataSource1,
			'multiSelect': true,
			'selectable': true,
			'cacheItems': true,
			'linkage': true,//开启节点联动
			'open-icon' : 'ace-icon tree-minus',
			'close-icon' : 'ace-icon tree-plus',
			'selected-icon' : 'ace-icon fa fa-check',
			'unselected-icon' : 'ace-icon fa fa-times'
		});
		$('#role_authorize-tree').one('loaded.fu.tree', function (event, data) {
			$('#role_authorize-tree').tree('discloseAll');
		});
	});
</script>

<div class="clearfix">
	<div class="col-sm-12">
		<!-- div.treeview_borderWrap -->
		<div class="widget-header">
			<span class="widget-title">
		       	<button class="btn btn-sm btn-info" onclick="javascript:ns_role_authorize.save();">
		       		<i class="fa fa-floppy-o"></i>&nbsp;&nbsp;保存</button>
		       	<button class="btn btn-sm btn-default" onclick="javascript:ns_role_authorize.back();">
		       		<i class="fa fa-reply"></i>&nbsp;&nbsp;返回</button>
		  	</span>
		  	<h5 class="widget-title lighter smaller pull-right">当前角色：${model.title}&nbsp;&nbsp;</h5>
		</div>
		<div class="widget-body">
			<div class="widget-main">
				<ul class="tree" role="tree" id="role_authorize-tree">
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
