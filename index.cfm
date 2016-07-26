<cfscript>
	local.Project = {
		author = "J Harvey",
		authorEmail = "jharvey@cfmaniac.com",
		systemName = 'DataManager Model Generator',
		version = '1.0.0',
		comDir = '#expandPath('/generated/')#',
		updates = 'Initial Creation of Data Manager Model Generator | All Generated Files have a <em>dm_</em> Prefix'
	};
	
	//Removes WhiteSpace from The Component
	public function  removeWhitepace(required string stringtoclean){
		var tempstring ='';
		tempstring = arguments.stringtoclean;
		tempstring = replace(tempstring, "#Chr(9)#", "","ALL"); 
        //tempstring = replace(tempstring, "#Chr(13)##Chr(10)#", "","ALL"); 
        //tempstring = replace(tempstring, "#Chr(13)#", "", "ALL");
        //tempstring = replace(tempstring, "#Chr(10)#", "", "ALL");
        return tempstring;
	}
</cfscript>

<cfoutput>
	<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>#local.Project.systemName# #local.Project.version#</title>
  <meta name="description" content="#local.Project.systemName# #local.Project.version#" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimal-ui" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  
  <meta name="mobile-web-app-capable" content="yes">
 
  
  <!-- style -->
  <link rel="stylesheet" href="assets/animate.css/animate.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/bootstrap/dist/css/bootstrap.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/styles/app.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/styles/font.css" type="text/css" />
</head>
<body>
  <header>
      <nav class="navbar navbar-md navbar-fixed-top white">
        <div class="container">
          <a data-toggle="collapse" data-target="##navbar-1" class="navbar-item pull-right hidden-md-up m-a-0 m-l">
            <i class="fa fa-bars"></i>
          </a>
          
          <!-- brand -->
          <a class="navbar-brand md" href="##home" ui-scroll-to="home">
            
            <span class="hidden-folded inline">#local.Project.systemName#</span>
          </a>
          <!-- / brand -->

          <!-- nabar right -->
          <ul class="nav navbar-nav pull-right">
            <li class="nav-item">
              
            </li>
          </ul>
          <!-- / navbar right -->
          <!-- navbar collapse -->
          <div class="collapse navbar-toggleable-sm text-center white" id="navbar-1">
            
            <!-- / link and dropdown -->
          </div>
          <!-- / navbar collapse -->
        </div>
      </nav>
  </header>
  
  <div class="page-content" id="home">
        <div class="p-y-lg white" id="demos">
      <div class="container p-y-lg text-primary-hover">
        <p class="text-muted m-b-lg">#local.project.systemname# automatically generates DataManager XML Models based off of your
        Datasource's Database tables.</p>
        
        <form role="form" method="post" class="ng-pristine ng-valid">
        <div class="form-group">
        <label for="exampleInputEmail1">Put your Datasource Name Below</label>
            <input type="text" class="form-control" name="dsn" id="dsn" placeholder="myDataSource">
        </div>
        
        <button type="submit" class="btn btn-outline rounded b-success text-success">Submit</button>
        </form>
        
        
        <cfif isdefined('form.dsn')>
        <h5 class="m-y-lg text-muted text-center">Generating your Components from <em>#form.dsn#</em></h5>
        <div style="height: 350px; overflow: auto;">
        <!---SET and Create the Component Directory--->
        <cfset local.compDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "generated/#form.dsn#/" />
		<cfif (DirectoryExists(local.compDir) EQ FALSE)>
			<cfdirectory action="create" directory="#local.compDir#" />
		</cfif>
		<!---End Component Directory Creation--->
		<!---Begin the Generation--->
        <cfdbinfo datasource="#form.dsn#" name="dsnTables" type="tables" />
	        <cfquery name="getNonSysTables" dbtype="query">
				SELECT REMARKS, TABLE_NAME, TABLE_TYPE
				FROM dsnTables
				WHERE TABLE_TYPE <> 'SYSTEM TABLE'
				AND TABLE_TYPE <> 'VIEW'
				AND TABLE_NAME NOT Like '%trace_%'
			</cfquery>
		    
		    <cfdbinfo datasource="#form.dsn#" name="getColumns" type="columns" table="#getNonSysTables.TABLE_NAME#" />
		    <cfdbinfo datasource="#form.dsn#" name="getfKeys" type="foreignkeys" table="#getNonSysTables.TABLE_NAME#">
		    	    
			<cfloop query="getNonSysTables">
			<cfdbinfo datasource="#form.dsn#" name="local.getColumns" type="columns" table="#getNonSysTables.TABLE_NAME#" />
			<!---The CFSAVECONTENT has been Shifted "Against the Wall" to Preserve Component Formatting--->
	        <cfsavecontent variable="DMGRcomp">
<tables>

<!-- [[ Table: #getNonSysTables.TABLE_NAME# ]] -->
	<table name="#getNonSysTables.TABLE_NAME#">
	<cfloop query="local.getColumns" ><cfset local.datatype = '' />
	<!---#local.getColumns.type_name#
	<cfabort>--->
	<cfswitch expression="#local.getColumns.type_name#" >
	    <!---Numeric/Integer Types--->
		<cfcase value="int identity,int"><cfset local.datatype = 'cf_sql_integer'></cfcase>
		<cfcase value="tinyint"><cfset local.datatype = 'cf_sql_tinyint'></cfcase>
		<cfcase value="numeric"><cfset local.datatype = 'cf_sql_numeric'></cfcase>
		<cfcase value="varbinary"><cfset local.datatype = 'cf_sql_varbinary'></cfcase>
		<cfcase value="float"><cfset local.datatype = 'cf_sql_float'></cfcase>
		<!---Boolean--->
		<cfcase value="bit"><cfset local.datatype = 'cf_sql_bit'></cfcase>
		<!---The String Types--->
		<cfcase value="char"><cfset local.datatype = 'cf_sql_varchar'></cfcase>
		<cfcase value="nchar"><cfset local.datatype = 'cf_sql_varchar'></cfcase>
		<cfcase value="varchar"><cfset local.datatype = 'cf_sql_varchar'></cfcase>
		<cfcase value="nvarchar"><cfset local.datatype = 'cf_sql_varchar'></cfcase>
		<cfcase value="text"><cfset local.datatype = 'cf_sql_longvarchar'></cfcase>
		<!---Date/Time Types--->
		<cfcase value="datetime"><cfset local.datatype = 'cf_sql_date'></cfcase>
	</cfswitch>
	<field ColumnName="#local.getColumns.column_name#" CF_DataType="#local.datatype#" <cfif local.datatype is "cf_sql_varchar">Length="#local.getColumns.column_size#"</cfif>
	<cfif #local.getColumns.type_name# is "int identity">PrimaryKey="true" Increment="true" AllowNulls="No" <cfelse>AllowNulls="YES"</cfif>  />
	
</cfloop>
</table>
</tables>		        
	        </cfsavecontent>
	        <cfscript>
		       DMGRcomp = removeWhitepace(DMGRcomp);
	        </cfscript>
	        <cffile action="write" file="#expandpath('generated/#form.dsn#/dm_#getNonSysTables.TABLE_NAME#.xml.cfc')#" output="#DMGRcomp#" nameconflict="overwrite">
	        <div class="alert alert-info">
		       Component <strong>#getNonSysTables.TABLE_NAME#.xml.cfc</strong> Generated 
	        </div>
	        </cfloop>
        <!---END The Generation--->
        </div>
        
        <p></p>
        <div class="alert alert-success">
        Your DataManager Models now Reside in the folder: <em>#local.compDir#</em>
        </div>
        </cfif>
        
      </div>
    </div>
  </div>
  
  <footer class="black pos-rlt">
    <div class="footer dk">
      
      <div class="b b-b"></div>
      <div class="p-a-md">
        <div class="row footer-bottom">
          <div class="col-sm-8">
            <small class="text-muted">&copy; Copyright 2014-#dateFormat(now(), "YYYY")#. All rights reserved.</small>
          </div>
          <div class="col-sm-4">
            <div class="text-sm-right text-xs-left">
              <strong>#local.project.systemNAme# by #local.project.author#</strong>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer> 
  <script src="libs/jquery/jquery/dist/jquery.js"></script>
  <script src="libs/jquery/tether/dist/js/tether.min.js"></script>
  <script src="libs/jquery/bootstrap/dist/js/bootstrap.js"></script>
  <script src="html/scripts/ui-scroll-to.js"></script>
</body>
</html>  
</cfoutput>