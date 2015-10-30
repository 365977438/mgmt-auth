<script src="./assets/js/jquery.validate.js"></script>
<script src="./assets/js/jquery.validate-zh-CN.js"></script>

<#import "/spring.ftl" as spring />

<script type="text/javascript">
jQuery(function($) {
	$('#sys_resource-edit-form').validate({
		errorElement: 'div',
		errorClass: 'help-block',
		focusInvalid: false,
		ignore: "",
		rules: {
			title: {
				required: true
			},
			code: {
				required: true,
				minlength: 6,
				remote: {
			        url: sys.basePath + "/sys_resource/checkResourceCode.do",
			        type: "post",
			        data: {
			          id: function() {
			        	  return $('#id').val();
			          },
			          code: function() {
			            return $("#code").val();
			          }
			        }
			      }
			},
			url: {
				required: true
			}
		},
	
		messages: {
			
		},
	
		highlight: function (e) {
			$(e).closest('.form-group').removeClass('has-info').addClass('has-error');
		},
	
		success: function (e) {
			$(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
			$(e).remove();
		}
	});
});

var sys_resource_edit = {};

sys_resource_edit.save = function() {
	if (!$('#sys_resource-edit-form').valid()) {
		return;
	}
	var obj = sys.form2Object('#sys_resource-edit-form');
	$.ajax({
		url: $('#sys_resource-edit-form').attr('action'),
		type: "POST",
		dataType: "json",
		data: {"object": JSON.stringify(obj)},
		success:function(response,st, xhr) {
			if(typeof(response.success)=="undefined"){
				sys.alertInfo("无结果返回/登录超时或未登录", 'danger');
				return;
			}
			if (response.success == true) {
				sys.alertInfo(response.msg, 'success');
				sys.backInTab('sys_resource_index');
			}else {
				console.error(response.msg);
				sys.alertInfo(response.msg, 'danger');
			}
		},
		error:function(xhr,type,msg){
			console.error(msg);
			sys.alertInfo(msg, 'danger');
		}
	});
};

sys_resource_edit.back = function() {
	sys.backInTab('sys_resource_index');
};
</script>
<form class="form-horizontal" id="sys_resource-edit-form" method="post" action="${ctx.getContextPath()}/sys_resource/save.do">
		
	<input type="hidden" name="id" id="id" value="${(model.id)!}"/>
	<input type="hidden" name="parentId" id="parentId" value="${(model.parentId)!}"/>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="systemName">所属系统:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="systemName" id="systemName" value="${(model.systemName)!}"
					class="col-xs-12 col-sm-5"/>
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="parentId">上级菜单:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="parentName" id="parentName" value="${(parentName)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="type">类型:</label>

		<div class="col-xs-12 col-sm-3">
			<div class="clearfix">
  					<@spring.formSingleSelect "model.type", resourceTypeOptions, ""/>
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="orderNum">排列序号:</label>

		<div class="col-xs-12 col-sm-3">
			<div class="clearfix">
  				<input type="text" name="orderNum" id="orderNum" value="${(model.orderNum)!}"
					class="col-xs-12 col-sm-2" />
			</div>
		</div>
	</div>
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="title">资源名称:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="title" id="title" value="${(model.title)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="code">资源编码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="code" id="code" value="${(model.code)!}"
					class="col-xs-12 col-sm-5" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>
		
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="url">资源URL:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="url" id="url" value="${(model.url)!}"
					class="col-xs-12 col-sm-8" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
		
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="url">菜单图标:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="iconClass" id="iconClass" value="${(model.iconClass)!}"
					class="col-xs-12 col-sm-8" placeholder="一级菜单才需要指定，如menu-icon fa fa-cubes"/>
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	<div class="form-group">
		<div class="col-xs-12 col-sm-9 center">
			<div class="clearfix">
				<button type="button" class="btn btn-info" onclick="javascript:sys_resource_edit.save();">
   					<i class="ace-icon fa fa-floppy-o"></i>保存
 				</button>
 				<button type="button" class="btn btn-default" onclick="javascript:sys_resource_edit.back();">
   					<i class="ace-icon fa fa-times red2"></i>取消
 				</button>
			</div>
		</div>
	</div>
</form>