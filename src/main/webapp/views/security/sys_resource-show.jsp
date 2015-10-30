<#import "/spring.ftl" as spring />

<form class="form-horizontal">
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="parentId">上级菜单:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="parentId" id="parentId" value="${(parentName)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>
	
		<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="type">类型:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
  				<@spring.formSingleSelect "model.type", resourceTypeOptions, "disabled='disabled'"/>
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
					class="col-xs-12 col-sm-5" readonly="readonly"/>
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
					class="col-xs-12 col-sm-5" readonly="readonly"/>
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
					class="col-xs-12 col-sm-8" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="createTime">创建时间:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="createTime" id="createTime" value="${((model.createTime)?datetime)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>
		
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="createdBy">创建人:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="createdBy" id="createdBy" value="${(model.createdBy)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>
	
	<div class="space-2"></div>
	
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="updateTime">更新时间:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="updateTime" id="updateTime" value="${((model.updateTime)?datetime)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>

	<div class="space-2"></div>
		
	<div class="form-group">
		<label class="control-label col-xs-12 col-sm-3 no-padding-right"
			for="updatedBy">更新人:</label>

		<div class="col-xs-12 col-sm-9">
			<div class="clearfix">
				<input type="text" name="updatedBy" id="updatedBy" value="${(model.updatedBy)!}"
					class="col-xs-12 col-sm-5" readonly="readonly"/>
			</div>
		</div>
	</div>
</form>