package xpose 
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import spark.skins.spark.NumericStepperTextInputSkin;

	public class ParametersCollection
	{	
		private static var instance:ParametersCollection = null;
		
		private var parameters:Dictionary;
		
		public static function getInstance():ParametersCollection
		{
			if (instance == null)
			{
				instance = new ParametersCollection();
			}
			
			return instance;
		}
		
		//private!
		public function ParametersCollection()
		{
			if(instance)
			{
				throw new Error ("We cannot create a new instance, Please use ElementsContainer.getInstance()");
				return;
			}
			
			parameters = new Dictionary(); 
		}
		
		/*
		* Public Functions, that will be used by Facade
		*/
		
		public function lookupParameters(owner:*):void
		{
			var variables:XMLList = describeType( owner ).variable;
			var len:int = variables.length();
			
			for (var i:int = 0; i < len; i++)
			{
				var meta:XMLList = variables[i].metadata;
				var exposeMeta:XMLList = meta.(@name == "expose");
				
				if (exposeMeta.length())
				{
					var fantasyName:String = exposeMeta[0].arg.(@key == "fantasy").@value.toString();
					var value:* = exposeMeta[0].arg.(@key == "defaultValue").@value.toString();
					var paramName:String = variables[i].@name.toString();
					
					if (!isNaN(value))
					{
						value = Number(value);
					}
					
					if (this.parameters[fantasyName])
					{
						var eo:ExposedObjects = this.parameters[fantasyName];
						value = eo.currentValue;
					}
					else
					{
						//adiciona parametro ao dicionario, indexando pelo nome fantasia
						this.parameters[fantasyName] = new ExposedObjects(paramName, value);
					}
					
					ExposedObjects(this.parameters[fantasyName]).addExposable(owner);
					this.changeParameter(fantasyName, value, true);
				}
			}
		}
		
		public function getExposedParameters() : Array
		{
			var list:Array = new Array();
			for (var k:Object in this.parameters)
			{
				list.push(k);
			}
			
			return list;
		}
		
		public function prepareParametersToSave():String
		{
			return JSON.stringify(this.buildParametersToSave());
		}
		
		public function loadParameters(data:String) : void
		{
			var array:Array = JSON.parse(data) as Array;
			this.updateParameters(array);
		}
		
		public function changeParameter(fantasyName:String, value:*, onCreation:Boolean = false):void
		{
			var exposeObj:ExposedObjects = this.parameters[fantasyName];
			
			if (!exposeObj)
			{
				trace("exposeObjsec não encontrado para o parametro " + fantasyName);
				return;
			}
			
			var type:String = getQualifiedClassName(value);
			
			if (type != exposeObj.type)
			{
				trace("Type mismatch: " + type + " != " + exposeObj.type);
				return;
			}
			
			var variableName:String = exposeObj.attributeName;
			exposeObj.currentValue = value;
			
			for (var exposable:* in exposeObj.objects)
			{	
				//chama a classe para mudar o valor da variavel. Isso não é feito diretamente aqui pois é
				//possível que alguma restrição de classe não permita a mudança. Isso a classe que decide.
				if ("changeVariable" in exposable)
				{
					exposable.changeVariable(variableName, value); 
				}
				else
				{
					exposable[variableName] = value; 
				}
			}
			
			if (!onCreation)
				exposeObj.changeLog.push(value);
		}
		
		public function getParameterExposedObjects(fantasyName:String) : ExposedObjects
		{
			return this.parameters[fantasyName];		
		}
		
		/*
		* Private Functions
		*/
		
		private function updateParameters(data:Array) : void
		{
			for (var i:int = 0; i < data.length; i++)
			{
				var obj:Object = data[i];
				if (this.parameters[obj.fantasyName])
				{
					this.changeParameter(obj.fantasyName, obj.value);
				}
				else
				{
					//adiciona parametro ao dicionario, indexando pelo nome fantasia (nesse caso ainda não existe 
					//nenhuma instancia do parametro, mas quando existir vai usar esse valor
					this.parameters[obj.fantasyName] = new ExposedObjects(obj.attributeName, obj.value);
				}
			}
		}
		
		private function buildParametersToSave() : Array
		{
			var data:Array = new Array();
			for (var param:Object in this.parameters)
			{
				var obj:Object = new Object();
				var eo:ExposedObjects = this.parameters[param];
				
				obj.fantasyName = param;
				obj.attributeName = eo.attributeName;
				obj.value = eo.currentValue;
				obj.changeLog = eo.changeLog;
				
				data.push(obj);
			}
			
			return data;
		}
	}
}