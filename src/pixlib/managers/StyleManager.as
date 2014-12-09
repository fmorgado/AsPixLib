package pixlib.managers {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import pixlib.logging.logger;
	
	public class StyleManager {
		private static const _providers:Dictionary = new Dictionary();
		private static const _aliases:Dictionary = new Dictionary();
		
		private static function resolveClass(type:*):Class {
			if (type is Class) {
				return type as Class;
			} else if (type is String) {
				try {
					return Class(getDefinitionByName(type));
				} catch(e:Error) {
					logger.error('Invalid class name', {type: String(type)}, StyleManager);
					return null;
				}
			} else {
				throw new ArgumentError('Invalid type argument:  ' + type);
			}
			return null;
		}
		
		public static function addStyle(type:*, provider:Function):void {
			const typeClass:Class = resolveClass(type);
			if (typeClass == null) return;
			_providers[typeClass] = provider;
		}
		
		public static function addAlias(type:*, alias:*):void {
			const typeClass:Class = resolveClass(type);
			if (typeClass == null) return;
			const aliasClass:Class = resolveClass(alias);
			if (aliasClass == null) return;
			_aliases[typeClass] = aliasClass;
		}
		
		public static function style(object:*):void {
			var type:Class = Class(getDefinitionByName(getQualifiedClassName(object)));
			var loop:uint = 0;
			while (true) {
				const provider:Function = _providers[type] as Function;
				if (provider != null) {
					provider(object);
					return;
				}
				
				type = _aliases[type];
				if (type == null) {
					//logger.warning('No style definition', {object: String(object)}, StyleManager);
					return;
				}
				
				loop++;
				if (loop > 10) {
					logger.error('Possible circular aliases', {object: String(object)}, StyleManager);
					return;
				}
			}
		}
		
	}
}