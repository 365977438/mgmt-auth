<script src="./assets/js/jquery.validate.js"></script>

<script type="text/javascript">
jQuery(function($) {
	
	$('#role-edit-form').validate({
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
				minlength: 5
			},
			description: {
				required: false
			}
		},
	
		messages: {
			title: {
				required: "请输入名称."
			},
			code: {
				required: "请输入编码.",
				minlength: "编码长度至少5位."
			}
		},
	
	
		highlight: function (e) {
			$(e).closest('.form-group').removeClass('has-info').addClass('has-error');
		},
	
		success: function (e) {
			$(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
			$(e).remove();
		},
	
		submitHandler: function (form) {
		},
		invalidHandler: function (form) {
		}
	});
});

var role_show = {};

role_show.save = function() {
	var obj = sys.form2Object('#role-edit-form');
	$.ajax({
		url: $('#role-edit-form').attr('action'),
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
				sys.backInTab('role_index');
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

role_show.back = function() {
	sys.backInTab('role_index');
};
</script>
<form class="form-horizontal" id="role-edit-form" method="post" action="${ctx.getContextPath()}/role/save.do">
	<input type="hidden" name="id" id="id" value="${(role.id)!}"/>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="title">角色名称:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="title" id="title" value="${(role.title)!}"
					class="col-xs-12 col-sm-8" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password">角色编码:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="code" id="code" value="${(role.code)!}"
					class="col-xs-12 col-sm-8" />
			</div>
		</div>
	</div>

	<div class="space-2"></div>

	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">描述:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="description" id="description" value="${(role.description)!}"
					class="col-xs-12 col-sm-12" />
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="password2">可否可用:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="checkbox" class="ace ace-switch ace-switch-5 col-xs-12 col-sm-12" name="status" id="status" <#if role??&&role.status>checked</#if>/>
				<span class="lbl middle"></span>
			</div>
		</div>
	</div>
	
	<div class="form-group">
		<div class="col-xs-12 col-sm-9 center">
			<div class="clearfix">
				<button type="button" class="btn btn-info" onclick="javascript:role_show.save();">
   					<i class="ace-icon fa fa-floppy-o"></i>保存
 				</button>
 				<button type="button" class="btn btn-default" onclick="javascript:role_show.back();">
   					<i class="ace-icon fa fa-times red2"></i>取消
 				</button>
			</div>
		</div>
	</div>
	<div class="hr hr-dotted"></div>
</form>