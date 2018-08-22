/**
* @name: models.base.service
* @hint: I create service objects with extra tools
* @author: Chris Schroeder (schroeder@jhu.edu)
* @created: Tuesday, 06/16/2015 07:54:17 AM
* @modified: Tuesday, 06/16/2015 07:54:17 AM
*/
component singleton
	output="false"
	displayName="models.base.service"
	accessors="true"
	hint="I create service objects with extra tools"
	extends=models.base.coursePlusObject
{

	/**
	* @name:	service.configure
	* @hint:	I configure the tool for use as a standalone service
	* @returns:	models.base.service
	* @date:	Thursday, 03/16/2017 09:36:49 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	private Void function configure(
		String cacheName='serviceObject',
		Struct paramAliases={}
	){
		super.configureCPObject(argumentCollection=arguments);
	}

	public models.base.service function init(
		Struct blueprints={},
		String cacheName='default',
		String cacheRegion='',
		Array cacheScopes=[],
		Struct cacheTypes={},
		String caller=GetMetaData(this)['FULLNAME'],
		Struct child={},
		Date compareDate=CreateDateTime(1970,1,1,0,0,0),
		String ctlemail='ctlhelp@jhu.edu',
		Boolean debugMode=false,
		Date defaultDate=CreateDateTime(1969,12,31,23,59,59),
		String defaultLog='models.base',
		Struct paramAliases={},
		Boolean sharedCache=false,
		String supportEmail='ctlhelp@jhu.edu'
	){
		configure(argumentCollection=arguments);
		return this;
	}

	public Any function returnService(){
		return this;
	}

	public Struct function returnProperties(){
		return this.getObjectAsStructure(argumentCollection=arguments);
	}

	/**
	* @name:	models.base.service.sendToDeveloper
	* @hint:	I send variable dumps to the developer for this object
	* @returns:	Boolean
	* @date:	Monday, 05/29/2017 10:06:18 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Boolean function sendToDeveloper(
		String subject='Send To Developer',
		Array params=[]
	){
		var result=false;
		if(ArrayLen(params) && Len(Trim(this.getdeveloperEmail())) ){
			savecontent variable="mailMeText"{
				ArrayEach(arguments.params,function(item){
					WriteDump(var=item);
				});
			}
			var mailer=new Mail(
				subject=arguments.subject,
				to=this.getdeveloperEmail(),
				from=( Len(Trim(this.getsupportEmail())) )?this.getsupportEmail():this.getdeveloperEmail(),
				type="text/html"
			);
			mailer.send(body=mailMeText);
			result=true;
		}
		return result;
	}

	/**
	* @name:	models.base.service.queryRowToStruct
	* @hint:	I process data sent as an array inside a form
	* @returns:	Struct
	* @date:	Sunday, 05/21/2017 10:38:44 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function queryRowToStruct( required Query qry,row=1 ){
		var resultArray=QueryToArray(qry=arguments.qry);
		var result={};
		var total=ArrayLen(resultArray);
		if( total>=arguments.row ){
			result=resultArray[arguments.row];
		} else if(total){
			result=resultArray[1];
		}
		return result;
	}

	/**
	* @name:	models.base.service.handleFormArray
	* @hint:	I process data sent as an array inside a form
	* @returns:	Array
	* @date:	Tuesday, 01/24/2017 08:14:03 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function handleFormArray(
		required Any formArray=[]
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':[],
			'processed':[]
		};
		try{
			if( isValid('struct',arguments.formArray) ){
				StructEach(arguments.formArray,function(key,value){
					ArrayAppend(errorStruct.processed,value);
				});
			} else if( isValid('array',arguments.formArray ) ){
				errorStruct['processed']=arguments.formArray;
			} else if( isJSON(arguments.formArray) ){
				errorStruct['processed']=DeserializeJSON(ReplaceNoCase(Trim(arguments.formArray),'//','','ONE'));
			} else if( isSimpleValue(arguments.formArray) && Len(Trim(arguments.formArray)) ){
				try{
					errorStruct['processed']=DeserializeJSON(ReplaceNoCase(Trim(arguments.formArray),'//','','ONE'));
				} catch( Any se ){
					errorStruct['processed']=ListToArray(Trim(arguments.formArray));
				}
			}
			if( isValid('array',errorStruct.processed) ){
				ArrayEach(errorStruct.processed,function(item){
					if( isSimpleValue(item) ){
						ArrayAppend(errorStruct.result,Trim(item));
					} else {
						ArrayAppend(errorStruct.result,item);
					}
				});
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".handleFormArray()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.updateCourseOfferingIDInString
	* @hint:	I return the string with an old courseOfferingID replaced by the current one
	* @date:	Monday, 08/22/2016 08:23:54 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public String function updateCourseOfferingIDInString( required String url,required Numeric courseOfferingID ){
		var result=arguments.url;
		if( ReFindNoCase("\/coID\/[0-9]{0,11}",arguments.url) && !( FindNoCase('/coID/'&arguments.courseOfferingID,arguments.url)) ){
			result=ReReplaceNoCase(arguments.url,"\/coID\/[0-9]{0,11}","/coID/"&arguments.courseOfferingID,'ONE');
		} else if ( ReFindNoCase("\/courseOfferingID\/[0-9]{0,11}",arguments.url) && !( FindNoCase('/courseOfferingID/'&arguments.courseOfferingID,arguments.url)) ){
			result=ReReplaceNoCase(arguments.url,"\/courseOfferingID\/[0-9]{0,11}","/courseOfferingID/"&arguments.courseOfferingID,'ONE');
		}
		return result;
	}

	public String function makeFunctName( required String functName,required String objName ){
		return arguments.objName & '.' & arguments.functName & '()';
	}

	/**
	* @name:	service.MergeSort
	* @hint:	I sort arrays
	* @date:	Thursday, 07/07/2016 10:35:35 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function MergeSort(
		required Array Arr,
		required Any key
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'leftArray':[],
			'rightArray':[],
			'middle':0,
			'result':[]
		};
		var i=0;
		try{
			if( ArrayLen(arguments.Arr) <= 1 ){
				errorStruct['result']=arguments.Arr;
			} else {
				errorStruct['middle']=Ceiling(ArrayLen(arguments.Arr)/2);
				for( i=1;i<=errorStruct.middle;i++ ){
					ArrayAppend(errorStruct.leftArray,arguments.Arr[i]);
				}
				for( i=errorStruct.middle+1;i<=ArrayLen(arguments.Arr);i++ ){
					ArrayAppend(errorStruct.rightArray,arguments.Arr[i]);
				}
				errorStruct['leftArray']=MergeSort(errorStruct.leftArray,arguments.key);
				errorStruct['rightArray']=MergeSort(errorStruct.rightArray,arguments.key);
				errorStruct['result']=Merge(errorStruct.leftArray,errorStruct.rightArray,arguments.key);
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".MergeSort()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name:		service.isUnique
	 * @package:	models.base.
	 * @hint:		I find whether items with the key already exist
	 * @returns:	Boolean
	 * @date:		Wednesday, 08/16/2017 01:07:32 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Boolean function isUnique(
		required Any source,
		required String key
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'params':arguments.filter(function(key,value){
				return (!isNull(value) && filterIsBasic(key,value));
			}),
			'result':false
		};
		try{
			if( Len(Trim(arguments.key)) ){
				if( isValid('struct',arguments.source) ){
					errorStruct['result']=( structKeyExists(arguments.source,arguments.key) )?false:true;
				} else if( isValid('array',arguments.source) ){
					errorStruct['result']=ArrayLen(arguments.source.filter(function(item){
						if( !isValid('struct',item) ){
							return false;
						} else {
							var itemKeys=structKeyArray(item);
							var keyLoc=ArrayFindNoCase(itemKeys,errorStruct.params.key);
							return (keyLoc && StructKeyExists(item,itemKeys[keyLoc]))?false:true;
						}
					}))?false:true;
				} else if( isValid('string',arguments.source) && Len(Trim(arguments.source)) && Find(',',arguments.source) ){
					errorStruct['result']=( ListFindNoCase(arguments.source,arguments.key,',') )?false:true;
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".isUnique()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.Merge
	* @hint:	I merge to an array
	* @date:	Thursday, 07/07/2016 10:30:49 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function Merge(
		required Array leftArray,
		required Array rightArray,
		required Any key
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':[]
		};
		try{
			while ( ArrayLen( arguments.leftArray ) > 0 && ArrayLen( arguments.rightArray ) > 0 ){
				if( arguments.leftArray[ 1 ][ arguments.key ] <= arguments.rightArray[ 1 ][ arguments.key ] ){
					ArrayAppend( errorStruct.result, arguments.leftArray[ 1 ] );
					ArrayDeleteAt( arguments.leftArray, 1 );
				} else {
					ArrayAppend( errorStruct.result, arguments.rightArray[ 1 ] );
					ArrayDeleteAt( arguments.rightArray, 1 );
				}
			}
			if( ArrayLen( arguments.leftArray ) > 0 ){
				errorStruct['result']=ArrayJoin( errorStruct.result, arguments.leftArray );
			}
			if( ArrayLen( arguments.rightArray ) > 0 ){
				errorStruct['result']=ArrayJoin( errorStruct.result, arguments.rightArray );
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".Merge()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.ArrayOfStructSort
	* @hint:	I sort struct keys inside an array
	* @date:	Thursday, 07/07/2016 10:45:15 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Array function ArrayOfStructSort(
		required Array base,
		String sortType="text",
		String sortOrder="ASC",
		String pathToSubElement=""
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':[],
			'keys':[],
			'tmpStruct':{}
		};
		var i=0;
		try{
			ArrayEach(arguments.base,function(item,idx){
				if( isValid('struct',item) ){
					errorStruct.tmpStruct[idx]=item;
				}
			});
			errorStruct['keys']=StructSort(errorStruct.tmpStruct,arguments.sortType,arguments.sortOrder,arguments.pathToSubElement);
			ArrayEach(errorStruct.keys,function(item,idx){
				ArrayAppend(errorStruct.result,errorStruct.tmpStruct[item]);
			});
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".ArrayOfStructSort()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	public Array function ArrayJoin(
		required Array base,
		required Array addOn
	){
		ArrayAppend(arguments.base,arguments.addOn,true);
		return arguments.base;
	}

	/**
	* @name:	models.base.service.replaceUnwantedCharacters
	* @hint:	Replaces unwanted characters
	* @date:	Wednesday, 07/06/2016 03:07:26 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Any function replaceUnwantedCharacters(
		required String str
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':arguments.str
		};
		try{
			var lEntities="c,o,a,I,C,E,O,E,A,A,E,y,Y,n,ss,,,,,,o,o,,,e,,,,,,f,,e,i,o,,a,,,o,,,a,o,i,ce,e,,,,c,,,a,,,e,i,o,,-,,,,,ce,,a,a,,,,,a,i,,,u,,,,s,,,,u,x,u,,,i,,u";
			var lEntitiesChars="ç,ô,â,Î,Ç,È,Ó,Ê,Â,À,É,ý,Ÿ,ñ,ß,´,·,–,®,‡,õ,ó,³,,é,¹,<,¢,¸,÷,ƒ,¿,ê,¡,ø,¬,à,ð,º,ö,°,ª,â,ò,ï,æ,è,¾,&,“,ç,ˆ,©,á,§,—,ë,ì,ô,¦,¯,½,¤,‘,…,œ,£,ã,ä,¼,•,€,µ,å,í,¶,»,û,”,‰,²,š,¥,±,þ,ù,×,ü,’,™,î,˜,ú";
			errorStruct['result']=ReplaceList( arguments.str,lEntitiesChars,lEntities );
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".replaceUnwantedCharacters()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.importNodes
	* @hint:	I put nodes into an array
	* @returns:	Any
	* @date:	Wednesday, 04/05/2017 03:03:46 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	private Any function importNodes(
		required xml doc,
		required Any children,
		Struct attrs={}
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':false,
			'xmlDoc':arguments.doc,
			'attrs':arguments.attrs
		};
		try{
			if( isValid('array',arguments.children) ){
				errorStruct['result']=[];
				ArrayEach(arguments.children,function(child){
					ArrayAppend(
						errorStruct.result,
						importNodes(
							doc=errorStruct.xmlDoc,
							children=child,
							attrs=errorStruct.attrs
						)
					);
				});
			} else if(structKeyExists(arguments.children,'xmlName') ){
				errorStruct['result']=XmlElemNew(errorStruct.xmlDoc,arguments.children.xmlName);
				if( StructKeyExists(arguments.children,'xmlAttributes')
					&& isValid('struct',arguments.children.xmlAttributes)
					&& StructCount(arguments.children.xmlAttributes)
				){
					StructAppend(errorStruct.result.xmlAttributes,arguments.children.xmlAttributes);
				}
				if( structCount(errorStruct.attrs)
					&& structKeyExists(errorStruct.attrs,arguments.children.xmlName)
					&& isValid('struct',errorStruct.attrs[arguments.children.xmlName])
					&& structCount(errorStruct.attrs[arguments.children.xmlName])
				){
					StructEach(errorStruct.attrs[arguments.children.xmlName],function(key,value){
						if( !isNull(value) ){
							appendAttrs(
								node=errorStruct.result,
								attrName=key,
								attrVal=value
							);
						}
					});
				}
				if( structKeyExists(arguments.children,'xmlText')
					&& Len(Trim(arguments.children.xmlText))
				){
					errorStruct.result['xmlText']=arguments.children.xmlText;
				}
				if( structKeyExists(arguments.children,'xmlChildren')
					&& isValid('array',arguments.children.xmlChildren)
					&& ArrayLen(arguments.children.xmlChildren)
				){
					ArrayAppend(
						errorStruct.result.xmlChildren,
						importNodes(
							doc=errorStruct.xmlDoc,
							children=arguments.children.xmlChildren,
							attrs=errorStruct.attrs
						),
						true
					);
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".importNodes()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.getOfferingEnrollment
	* @hint:	I return student enrollment for an offering
	* @returns:	Struct, Query, Array, List
	* @date:	Tuesday, 12/20/2016 07:06:51 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Any function getOfferingEnrollment(
		required Numeric courseOfferingID,
		String format='query',
		Boolean randomize=false,
		Query enrollmentQuery,
		Any myCoursesInterface
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':(
				FindNoCase('struct',arguments.format)
			)?{}:(
				FindNoCase('arr',arguments.format)
			)?[]:(
				FindNoCase('list',arguments.format)
			)?'':QueryNew('id','varchar'),
			'cacheName':'enrollment-studentsOnly-courseOfferingID'&arguments.courseOfferingID,
			'cacheRegion':returnCacheRegion(this.getsharedCache()),
			'qEnrollment':QueryNew('id','varchar'),
			'fromCache':false
		};
		try{
			if(
				(structKeyExists(arguments,'myCoursesInterface') && isObject(arguments.myCoursesInterface))
				|| (structKeyExists(arguments,'enrollmentQuery') && isValid('query',arguments.enrollmentQuery))
			){
				var cachedEnrollment=cacheGet(errorStruct.cacheName,errorStruct.cacheRegion);
				if( !isNull(cachedEnrollment) && isValid('query',cachedEnrollment) ){
					errorStruct['qEnrollment']=cachedEnrollment;
					errorStruct['fromCache']=true;
				} else {
					if( StructKeyExists(arguments,'enrollmentQuery') && isValid('query',arguments.enrollmentQuery) ){
						errorStruct['qEnrollment']=filterStudents(fullEnrollment=arguments.enrollmentQuery);
					} else {
						errorStruct['qEnrollment']=filterStudents(fullEnrollment=arguments.myCoursesInterface.getEnrollmentByOffering(arguments.courseOfferingID,500,599));
					}
					cachePut(errorStruct.cacheName,errorStruct.qEnrollment,CreateTimeSpan(0,1,0,0),CreateTimeSpan(0,1,0,0),errorStruct.cacheRegion);
				}
				if( arguments.format=='query' ){
					errorStruct['result']=errorStruct.qEnrollment;
				} else {
					var aEnrollment=QueryToArray(qry=errorStruct.qEnrollment);
					if(isValid('array',errorStruct.result)){
						errorStruct['result']=aEnrollment;
					} else {
						if( isValid('struct',errorStruct.result) ){
							errorStruct['result']=aEnrollment.reduce(function(result={},student){
								if( structKeyExists(student,'stuID') && isValid('numeric',student['stuID']) && student['stuID']){
									result[student.stuID]=student;
								}
								return result;
							});
						} else if( isSimpleValue(errorStruct.result) ){
							var stringResult=ArrayToList(aEnrollment.map(function(student){
								return student.stuID;
							}),',');
							if( arguments.randomize ){
								errorStruct['result']=randomizeKeys(stringResult);
							} else {
								errorStruct['result']=stringResult;
							}
						} else {
							throw(
								type='InvalidReturnType',
								message='The requested return type was invalid',
								detail='The type '&arguments.format&' is not valid for this function.',
								extendedInfo=SerializeJSON({arguments:arguments,result:errorStruct.result})
							);
						}
					}
				}
			} else {
				throw(
					type='NoDataSource',
					message='This method requires an interface to access enrollment data.',
					detail='There are two source options available: myCourses4 interface (facade or service), or query. Neither were provided when this method was called.',
					extendedInfo=SerializeJSON({argumentsProvided:StructKeyArray(arguments)})
				);
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() /*|| errorStruct.fromCache==false*/ ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".getOfferingEnrollment()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	service.appendAttrs
	* @hint:	I append an attr to an xmlnode
	* @returns:	Void
	* @date:	Tuesday, 04/11/2017 09:43:27 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	private Void function appendAttrs(
		required xml node,
		required String attrName,
		required Any attrVal
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{}
		};
		try{
			if( structKeyExists(arguments.node.xmlAttributes,arguments.attrName) ){
				arguments.node.xmlAttributes[arguments.attrName]=arguments.attrVal;
			} else {
				StructInsert(arguments.node.xmlAttributes,arguments.attrName,arguments.attrVal);
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".appendAttrs()",
				args=errorStruct
			);
		}
	}

	/**
	* @name:	service.buildBaseXml
	* @hint:	Builds a base coldspring service factory
	* @returns:	xml
	* @date:	Monday, 04/03/2017 11:11:52 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public xml function buildBaseXml(
		required String rootNode,
		required Struct attributes
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':XmlNew(),
			'rootNode':XmlNew()
		};
		try{
			errorStruct.result['xmlRoot']=XmlElemNew(errorStruct.result,arguments.rootNode);
			if( StructCount(arguments.attributes) ){
				var rootElem=arguments.rootNode;
				StructEach(arguments.attributes,function(key,value){
					errorStruct.result[rootElem].XmlAttributes[key]=value;
					errorStruct.result[rootElem].XmlChildren=[];
				});
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".buildBaseXml()",
				args=errorStruct
			);
		}
		return XmlParse(errorStruct.result);
	}

	/**
	* @name:	models.base.service.manageDecimals
	* @hint:	I manage decimal positions/placement
	* @date:	Wednesday, 07/06/2016 03:10:24 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Any function manageDecimals(
		required Any num,
		Numeric decimals=4
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':'',
			'format':"___."
		};
		var i=0;
		try{
			if( isSimpleValue(arguments.num)
				&& isValid('numeric',arguments.num)
				&& !(Find('NaN',arguments.num))
			){
				errorStruct['rounded']=round(arguments.num);
				for( i=1;i<=arguments.decimals;i++ ){
					errorStruct.format &= '_';
				}
				if( errorStruct.rounded!=arguments.num ){
					errorStruct['result']=LSParseNumber(NumberFormat(arguments.num,errorStruct.format));
				} else {
					errorStruct['result']=errorStruct.rounded;
				}
			} else if( arguments.num!='NaN' ) {
				errorStruct['result']=arguments.num;
			} else if( arguments.num=='NaN' ){
				errorStruct['result']=0;
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".manageDecimals()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	public String function getHashedReportFileName(
		Array identifiers=[],
		String encoding="SHA",
		String prefix="pe-"
	){
		var errorStruct={
			'prefix':arguments.prefix,
			'encodedName':'',
			'fileName':'',
			'logType':'warning',
			'arguments':arguments
		};
		try{
			var ai=0;
			errorStruct['fileName']=errorStruct.prefix;
			for( ai=1;ai<=ArrayLen(arguments.identifiers);ai++ ){
				errorStruct.encodedName &= arguments.identifiers[ai];
			}
			errorStruct.fileName &= Hash(errorStruct.encodedName,arguments.encoding);
			errorStruct['logType']="information";
		} catch ( any e ){
			errorStruct['cfcatch']=e;
			errorStruct['logType']="error";
		}
		if( errorStruct.logType != 'information' ){
			createLog(
				logName=this.getDefaultLog(),
				functName=this.getcaller()&".getHashedReportFileName()",
				logType=errorStruct.logType,
				args=errorStruct
			);
		}
		return errorStruct.fileName;
	}

	/**
	* @name:	service.returnStructModel
	* @hint:	I return a blueprint structure overwriting defaults with any values defined in the params arg
	* @returns:	Struct
	* @date:	Wednesday, 01/11/2017 07:51:38 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function returnStructModel(
		required String modelName,
		required Struct params
	){
		var blueprints=( isValid('struct',this.getblueprints()) )?this.getblueprints():{};
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'model':( StructKeyExists(blueprints,arguments.modelName) )?Duplicate(blueprints[arguments.modelName]):{},
			'result':{},
			'params':arguments.params,
			'paramKeys':StructKeyArray(arguments.params)
		};
		try{
			errorStruct['result']=errorStruct.model.map(function(key,value){
				var findKey=ArrayFindNoCase(errorStruct.paramKeys,key);
				var result=value;
				if( findKey ){
					var keyRef=errorStruct.paramKeys[findKey];
					if( structKeyExists(errorStruct.params,keyRef) && !isNull(errorStruct.params[keyRef]) ){
						result=errorStruct.params[keyRef];
					}
				}
				return result;
			});
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".returnStructModel()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name: models.base.service.objectToStruct()
	 * @hint: I convert objects to structures
	 * @returns: Struct
	 * @author: Chris Schroeder (schroeder@jhu.edu)
	 * @date: Friday, 07/01/2016 09:14:31 AM
	 */
	public Struct function objectToStruct(
		required Any obj,
		Array includeParents=[],
		Numeric currentLevel=1,
		Array extendedInclusions=['compareDate','defaultDate'],
		Boolean throwOnError=true
	){
		return importObject(argumentCollection=arguments);
	}

	public Boolean function hasConfigure(obj){
		var errorStruct={
			'metaData':{},
			'result':0,
			'counter':0
		};
		var f=0;
		try{
			if( isInstanceOf(arguments.obj,'models.base.coursePlusObject') || isInstanceOf(arguments.obj,'WEB-INF.cftags.component') ){
				if( structKeyExists(arguments.obj,'configure') ){
					errorStruct['counter']=1;
				} else {
					errorStruct['metaData']=getMetaData(arguments.obj);
					for( f in errorStruct.metaData.functions ){
						if( errorStruct.metaData.functions[f].name=='configure' ){
							errorStruct['counter']=errorStruct.counter+1;
						}
					}
				}
			}
			if( errorStruct.counter ){
				errorStruct['result']=1;
			}
		} catch( Any e ) {}
		return errorStruct.result;
	}

	public Boolean function checkForPrototype(n){
		var result=0;
		if( n.name=='setprototype' ){
			result=1;
		}
	}

	/**
	* @name:	service.zeroOut
	* @hint:	I reset objects
	* @returns:	Any
	* @date:	Wednesday, 05/24/2017 05:30:46 PM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Any function zeroOut(
		required Any obj,
		Array ignoreKeys=[],
		Array includeParents=[],
		Array extendedInclusions=['compareDate','defaultDate'],
		Numeric currentLevel=1,
		Boolean throwOnError=false
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{},
			'args':arguments.filter(function(key,value){
				return !isObject(value);
			}),
	 		'throwOnError':( this.getdebugMode() )?true:arguments.throwOnError,
			'persistArgs':{
				'ignoreKeys':arguments.ignoreKeys,
				'includeParents':arguments.includeParents,
				'extendedInclusions':arguments.extendedInclusions,
				'currentLevel':arguments.currentLevel+1
			},
			'workingObj':false
		};
		try{
			//prep objects before processing
			if( isInstanceOf(arguments.obj,'models.base.coursePlusObject') || isInstanceOf(arguments.obj,'WEB-INF.cftags.component') ){
				errorStruct['workingObj']=arguments.obj.getobjectAsStructure(
					includeParents=errorStruct.persistArgs.includeParents,
					currentLevel=errorStruct.args.currentLevel,
					extendedInclusions=errorStruct.args.extendedInclusions,
					throwOnError=errorStruct.throwOnError
				);
			} else {
				errorStruct['workingObj']=arguments.obj;
			}

			if( isValid('struct',errorStruct.workingObj) && StructCount(errorStruct.workingObj)){
				//annoying redundancy - filter before mapping
				var filteredStruct=StructFilter(errorStruct.workingObj,function(key,value){
					return !isNull(value);
				});
				var tmpStruct=StructMap(filteredStruct,function(key,value){
					var structArgs=errorStruct.persistArgs;
					structArgs['obj']=value;
					structArgs['key']=key;
					return zeroCallback( argumentCollection=structArgs );
				});
				errorStruct['workingObj']=tmpStruct;
			} else if( isValid('array',errorStruct.workingObj) || isValid('query',errorStruct.workingObj) ){
				//always convert queries to arrays first
				if( isValid('query',errorStruct.workingObj) ){
					var tmpQry=errorStruct.workingObj;
					errorStruct['workingObj']=QueryToArray(qry=tmpQry);
				}

				//annoying redundancy - filter before mapping
				var filteredArray=ArrayFilter(errorStruct.workingObj,function(aItem,aIdx){
					return ( !isNull(aItem) );
				});
				var tmpArray=ArrayMap(filteredArray,function(aItem,aIdx){
					var arrayArgs=errorStruct.persistArgs;
					arrayArgs['obj']=aItem;
					return zeroCallback( argumentCollection=arrayArgs );
				});
				errorStruct['workingObj']=tmpArray;
			} else if( isSimpleValue(errorStruct.workingObj) ){
				if( ( isValid('date',Trim(errorStruct.workingObj)) || isValid('time',Trim(errorStruct.workingObj)) )
					&& !isValid('numeric',Trim(errorStruct.workingObj))
					&& FindNoCase('ts ',Trim(errorStruct.workingObj))
				){
					errorStruct['workingObj']=this.getdefaultDate();
				} else if( isValid('numeric',Trim(errorStruct.workingObj))
					|| isValid('boolean',Trim(errorStruct.workingObj))
					|| isValid('integer',Trim(errorStruct.workingObj))
				){
					errorStruct['workingObj']=0;
				}
			}
			errorStruct['result']=errorStruct.workingObj;
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".zeroOut()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	private Any function zeroCallback(
		Any obj,
		String key,
		Array ignoreKeys=[],
		Array includeParents=[],
		Array extendedInclusions=[],
		Numeric currentLevel=1
	){
		var errorStruct={
			'arguments':arguments.filter(function(key,value){
				return (!isNull(value) && !(isObject(value)));
			}),
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':returnNull()
		};
		try{
			if( StructKeyExists(arguments,'obj') && !isNull(arguments.obj) ){
				if( structKeyExists(arguments,'key')
					&& Len(Trim(arguments.key))
					&& ArrayFindNoCase(arguments.ignoreKeys,Trim(arguments.key))
					&& !(isInstanceOf(arguments.obj,'models.base.coursePlusObject') || isInstanceOf(arguments.obj,'WEB-INF.cftags.component'))
				){
					errorStruct['result']=arguments.obj;
				} else {
					errorStruct['result']=zeroOut(
						argumentCollection=arguments.filter(function(key,value){
							return (key!='key');
						})
					);
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".zeroCallback()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
	/**
	 * @name:		service.filterStudents
	 * @hint:		I am a filter that returns only student rows from an enrollment query
	 * @returns:	Query
	 * @date:		Wednesday, 07/12/2017 04:10:09 PM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	private Query function filterStudents(
		required Query fullEnrollment,
		Numeric minUserLevel=500,
		Numeric maxUserLevel=599
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'sql':{
				'string':"",
				'prefix':{}
			},
			'result':QueryNew('id','varchar')
		};
		try{
			if( arguments.maxUserLevel<arguments.minUserLevel ){
				arguments.maxUserLevel=arguments.minUserLevel;
			}
			var queryService=new Query(
				name="qfilterStudents",
				dbtype='query'
			);
			queryService.setAttributes(enrollmentTable=fullEnrollment);
			savecontent variable="errorStruct.sql.string"{
				WriteOutput('
					SELECT *
					FROM enrollmentTable
					WHERE userLevel>=:minUserLevel
					AND userLevel<=:maxUserLevel
					ORDER BY lastName,firstName
				');
			}
			queryService.addParam(name='minUserLevel',value=arguments.minUserlevel,cfsqltype='cf_sql_numeric');
			queryService.addParam(name='maxUserLevel',value=arguments.maxUserlevel,cfsqltype='cf_sql_numeric');
			var queryData=queryService.execute(sql=errorStruct.sql.string);
			errorStruct.sql['prefix']=queryData.getPrefix();
			errorStruct['result']=queryData.getResult();
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".filterStudents()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name:		service.returnBeanDefinitions
	 * @hint:		I return the currently defined bean definitions
	 * @returns:	Struct
	 * @date:		Wednesday, 06/28/2017 09:35:10 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Struct function getBeanDefinitions(
		required Coldspring.beans.BeanFactory serviceFactory
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{},
			'definedBeans':{},
			'beanKeys':[]
		};
		try{
			var sf=arguments.serviceFactory;
			var rawBeanDefs=sf.getBeanDefinitionList();
			var filteredBeanDefs=rawBeanDefs.filter(function(key,value){
				return ( value.isFactoryBean() && !value.isAbstract() && Len(value.getBeanClass()) );
			});
			errorStruct['definedBeans']=filteredBeanDefs.map(function(key,value){
				var result={
					'isSingleton':value.isSingleton(),
					'beanClass':value.getBeanClass(),
					'dependencies':ArrayMap(ListToArray(value.getDependenciesForCopy(),','),
						function(item){
							if( StructKeyExists(filteredBeanDefs,item) && !FindNoCase('api',item) ){
								return ' <a href="##bf-'&item&'" class="bf-dependency-link">'&item&'</a>';
							} else {
								return '';
							}
						}
					),
					'isFactory':value.isFactoryBean(),
					'beanID':value.getBeanID(),
					'isLazyInit':value.isLazyInit(),
					'isConstructed':value.isConstructed()
				};
				var resultDependencies=result['dependencies'];
				result['dependencies']=ArrayToList(ArrayFilter(resultDependencies,function(dep){
					return (Len(Trim(dep)));
				}),', ');
				if( !(Len(Trim(result['dependencies']))) ){
					result['dependencies']='--';
				}
				return result;
			});
			errorStruct['result']=errorStruct.definedBeans;
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType!='information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".returnBeanDefinitions()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	 * @name:		service.filterIsBasic
	 * @package:	models.base.
	 * @hint:		I make recommendations whether to use/not use a key/value pair. I'm useful for logging or forensic use.
	 * @returns:	Boolean
	 * @date:		Friday, 07/28/2017 06:43:35 AM
	 * @author: 	Chris Schroeder (schroeder@jhu.edu)
	 */
	public Boolean function filterIsBasic(
		required String key,
		required Any value,
		Array forceIncludeKeys=[],
		Array forceExcludeKeys=[]
	){
		var errorStruct={
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'ignoreKeys':['monolithSession','beanFactoryReport','globalVars'],
			'forceKeys':[],
			'result':true
		};
		if( ArrayLen(arguments.forceIncludeKeys) ){
			ArrayAppend(errorStruct.forceKeys,arguments.forceIncludeKeys,true);
		}
		if( ArrayLen(arguments.forceExcludeKeys) ){
			ArrayAppend(errorStruct.ignoreKeys,arguments.forceExcludeKeys,true);
		}
		if( ( ArrayFindNoCase(errorStruct.ignoreKeys,Trim(arguments.key)) && !(ArrayFindNoCase(errorStruct.forceKeys,Trim(arguments.key))) )
			|| (isInstanceOf(arguments.value,'WEB-INF.cftags.component'))
		){
			errorStruct['result']=false;
		}
		return errorStruct['result'];
	}

	public String function paraFormat(
		required String unformattedText,
		String class='',
		String flag='',
		Boolean stripflag=0
	){
		var errorStruct={
			flag:'tinymceblock',
			className:'',
			formattedText:'',
			pattern:'#chr(10)##chr(13)#'
		};
		if( Len(Trim(arguments.flag)) ){
			errorStruct['flag']=arguments.flag;
		}
		if( Len(Trim(arguments.class)) ){
			errorStruct['className']=' class="#arguments.class#"';
		}
		if( !(Find(errorStruct.flag,arguments.unformattedText) ) ){
			errorStruct['listItems']="<p#errorStruct.className#>" & ReReplace(arguments.unformattedText,errorStruct.pattern,"</p><p#errorStruct.className#>","ALL") & "</p>";
			errorStruct['formattedText']=ReReplace(errorStruct.listItems, "<p#errorStruct.className#>\n</p>","","ALL");
		} else {
			errorStruct['formattedText']=Trim(arguments.unformattedText);
		}
		if( arguments.stripflag ){
			errorStruct['formattedText']=Replace(errorStruct.formattedText,"<span class=""#errorStruct.flag#end""></span></div>","","ONE");
			errorStruct['formattedText']=Replace(errorStruct.formattedText,"<span class=""#errorStruct.flag#end"">&nbsp;</span></div>","","ONE");
			errorStruct['formattedText']=Replace(errorStruct.formattedText,"<div class=""#errorStruct.flag#"">","","ONE");
		}
		return errorStruct.formattedText;
	}

	public String function randomizeKeys(String keyList=''){
		var errorStruct={
			stackTrace:getStackTrace(),
			arguments:arguments,
			logType:'warning',
			result:'',
			'keyData':{},
			'keys':ListToArray(arguments.keyList,',')
		};
		var k=0;
		try{
			if( ArrayLen(errorStruct.keys) ){
				for( k=1;k<=ArrayLen(errorStruct.keys);k++ ){
					errorStruct.keyData[errorStruct.keys[k]]=RandRange(1111,9999);
				}
				errorStruct['result']=ArrayToList(StructSort(errorStruct.keyData,'numeric','ASC'),',');
			}
			errorStruct['logType']='information';
		} catch( Any e ){
			errorStruct['logType']='error';
			errorStruct['cfcatch']=e;
		}
		if( errorStruct.logType != 'information' ){
			createLog(
				logName=this.getDefaultLog(),
				functName="gateway.randomizeKeys()",
				logType=errorStruct.logType,
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	remote String function makeSlug( String title='', String divider='-' ){
		if( !( Len(Trim(arguments.title)) ) ){
			arguments['title']='title';
		}
		if( !( Len(Trim(arguments.divider)) ) ){
			arguments['divider']='-';
		}
		var str=ReReplace(LCase(trim(arguments.title)),'[^0-9_a-zA-Z\\(\\)\\%\\-\\.]',arguments.divider,'ALL');
		str=ReReplace(str,'[\'&arguments.divider&']{2,}',arguments.divider,'ALL');
		return str;
	}

	public Numeric function wordCount(wordsToCount){
		return listLen(arguments.wordsToCount, " #chr(9)##chr(10)##chr(11)##chr(12)##chr(13)#");
	}

	public String function stripHTML( required String unformattedText ){
		return ReReplace(arguments.unformattedText,"<[^>]*>","","ALL");
	}

	/**
	* @name:	models.base.service.xmlNodeToStruct
	* @hint:	I convert an xmlNode to a structure
	* @date:	Monday, 08/08/2016 08:21:15 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function xmlNodeToStruct(
		required xmlObject
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{
				'name':'',
				'propertyCount':0,
				'childCount':0,
				'text':'',
				'children':{}
			}
		};
		try{

			if( structKeyExists(arguments.xmlObject,'xmlText') ){
				errorStruct.result['text']=arguments.xmlObject.xmlText;
			}
			if( structKeyExists(arguments.xmlObject,'xmlName') ){
				errorStruct.result['name']=arguments.xmlObject.xmlName;
			}
			if( structKeyExists(arguments.xmlObject,'xmlAttributes') ){
				errorStruct.result['propertyCount']=StructCount(arguments.xmlObject.xmlAttributes);
			}
			if( structKeyExists(arguments.xmlObject,'xmlChildren') ){
				errorStruct.result['childCount']=ArrayLen(arguments.xmlObject.xmlChildren);
			}
			if( errorStruct.result.propertyCount ){
				for( var pc in arguments.xmlObject.xmlAttributes ){
					errorStruct.result[UCase(pc)]=arguments.xmlObject.xmlAttributes[pc];
				}
			}
			if( errorStruct.result.childCount ){
				errorStruct.result['children']=xmlExtractChildren(
					objectKey=arguments.xmlObject.xmlName,
					objectValue=arguments.xmlObject
				);
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".xmlNodeToStruct()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}

	/**
	* @name:	models.base.service.xmlExtractChildren
	* @hint:	I extract children from an xml object and return them as part of a structure
	* @date:	Monday, 08/08/2016 08:29:35 AM
	* @author:	Chris Schroeder (schroeder@jhu.edu)
	*/
	public Struct function xmlExtractChildren(
		required Any objectKey,
		required Any objectValue
	){
		var errorStruct={
			'arguments':arguments,
			'logType':"warning",
			'start':Now(),
			'stackTrace':getStackTrace(),
			'result':{
				'parent':arguments.objectKey,
				'propertyCount':0
			}
		};
		try{
			if( structKeyExists(arguments.objectValue,'xmlChildren') && isValid('array',arguments.objectValue.xmlChildren) ){
				errorStruct.result['propertyCount']=ArrayLen(arguments.objectValue.xmlChildren);
				for( var pc=1;pc<=errorStruct.result.propertyCount;pc++ ){
					if( !( StructKeyExists(errorStruct.result,LCase(arguments.objectValue.xmlChildren[pc].xmlName)) ) ){
						errorStruct.result[LCase(arguments.objectValue.xmlChildren[pc].xmlName)]=[];
					}
					ArrayAppend(
						errorStruct.result[LCase(arguments.objectValue.xmlChildren[pc].xmlName)],
						xmlNodeToStruct(xmlObject=arguments.objectValue.xmlChildren[pc])
					);
				}
			}
			errorStruct['logType']="information";
		} catch( Any e ){
			errorStruct['logType']="error";
			errorStruct['cfcatch']=e;
		}
		errorStruct['end']=Now();
		errorStruct['diff']=DateDiff('s',errorStruct.start,errorStruct.end);
		if( errorStruct.logType != 'information' || this.getdebugMode() ){
			createLog(
				logName=this.getdefaultLog(),
				logType=errorStruct.logType,
				functName=this.getcaller()&".xmlExtractChildren()",
				args=errorStruct
			);
		}
		return errorStruct.result;
	}
}
