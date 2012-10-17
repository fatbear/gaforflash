﻿/*
 * Copyright 2008 Adobe Systems Inc., 2008 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Contributor(s):
 *   Zwetan Kjukov <zwetan@gmail.com>.
 *   Marc Alcaraz <ekameleon@gmail.com>.
 */

package com.google.analytics.external
{
    import com.google.analytics.debug.DebugConfiguration;

	import core.uri;
    
    /**
     * Proxy access to HTML Document Object Model.
     */
    public class HTMLDOM extends JavascriptProxy
    {
        
        private var _host:String;
        private var _language:String;
        private var _characterSet:String;
        private var _colorDepth:String;
        private var _location:String;
        private var _pathname:String;
        private var _protocol:String;
        private var _search:String;
        private var _referrer:String;
        private var _title:String;
		private var _inIframe:Boolean;
		private var _parentUri:uri;
        private var _parentHost:String;
        private var _parentLocation:String;
        private var _parentPathname:String;
        private var _parentProtocol:String;
        private var _parentSearch:String;
        
        /**
         * The cache properties Javascript injection.
         */
        public static var cache_properties_js:XML =
        <script>
            <![CDATA[
                    function()
                    {
                        var obj = {};
                            obj.host         = document.location.host;
                            obj.language     = navigator.language ? navigator.language : navigator.browserLanguage;
                            obj.characterSet = document.characterSet ? document.characterSet : document.charset;
                            obj.colorDepth   = window.screen.colorDepth;
                            obj.location     = document.location.toString();
                            obj.pathname     = document.location.pathname;
                            obj.protocol     = document.location.protocol;
                            obj.search       = document.location.search;
                            obj.referrer     = document.referrer;
                            obj.title        = document.title;
							obj.inIframe     = window.location != window.parent.location;
                        
                        return obj;
                    }
                ]]>
         </script>;

        /**
         * The cache properties Javascript injection.
         */
        public static var in_iframe_js:XML =
        <script>
            <![CDATA[
                    function()
                    {
                        return window.location != window.parent.location;
                    }
                ]]>
         </script>;
                
        /**
         * Creates a new HTMLDOM instance.
         */
        public function HTMLDOM( debug:DebugConfiguration )
        {
            super( debug );
        }
        
        /**
         * Caches in one function call all the HTMLDOM properties.
         */
        public function cacheProperties():void
        {
            if( !isAvailable() )
            {
                return;
            }
            
            var obj:Object = call( cache_properties_js );
            
            if( obj )
            {
                _host         = obj.host;
                _language     = obj.language;
                _characterSet = obj.characterSet;
                _colorDepth   = obj.colorDepth;
                _location     = obj.location;
                _pathname     = obj.pathname;
                _protocol     = obj.protocol;
                _search       = obj.search;
                _referrer     = obj.referrer;
                _title        = obj.title;
                _inIframe     = obj.inIframe;

				if (_inIframe)
				{
					_parentUri = new uri( _referrer );
			        _parentHost      = _parentUri.authority;
			        _parentLocation  = _referrer;
			        _parentPathname  = _parentUri.path;
			        _parentProtocol  = _parentUri.scheme;
			        _parentSearch    = _parentUri.queryRaw;
				}
            }
        }
        
        /**
         * Determinates the 'host' String value from the HTML DOM.
         */
        public function get host():String
        {
            /* note:
               same logic applies for all properties
               
               cached values take precedence over ExternalInterface availability
               
               we first check if we have the cached value
               if yes returns it
               
               check for ExternalInterface availability,
               if not available returns null
               
               fetch the property and cache it
            */
            
            if( _host )
            {
                return _host;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _host = getProperty( "document.location.host" );
            
            return _host;
        }
        
        /**
         * Determinates the 'langage' String value from the HTML DOM.
         */
        public function get language():String
        {
            if( _language )
            {
                return _language;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            var lang:String = getProperty( "navigator.language" );
            
            if( lang == null )
            {
                lang = getProperty( "navigator.browserLanguage" );
            }
            
            _language = lang;
            
            return _language;
        }
        
        /**
         * Indicates the characterSet value of the html dom.
         */        
        public function get characterSet():String
        {
            if( _characterSet )
            {
                return _characterSet;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            var cs:String = getProperty( "document.characterSet" );
            
            if( cs == null )
            {
                cs = getProperty( "document.charset" );
            }
            
            _characterSet = cs;
            
            return _characterSet;
            
        }
        
        /**
         * Indicates the color depth of the html dom.
         */
        public function get colorDepth():String
        {
            if( _colorDepth )
            {
                return _colorDepth;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _colorDepth = getProperty( "window.screen.colorDepth" );
            
            return _colorDepth;
        }
        
        
        /**
         * Determinates the 'location' String value from the HTML DOM.
         */     
        public function get location():String
        {
            if( _location )
            {
                return _location;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _location = getPropertyString( "document.location" );
            
            return _location;
        }
        
        /**
         * Returns the path name value of the html dom.
         * @return the path name value of the html dom.
         */
        public function get pathname():String
        {
            if( _pathname )
            {
                return _pathname;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _pathname = getProperty( "document.location.pathname" );
            
            return _pathname;
        }
        
        /**
         * Determinates the 'protocol' String value from the HTML DOM.
         */       
        public function get protocol():String
        {
            if( _protocol )
            {
                return _protocol;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _protocol = getProperty( "document.location.protocol" );
            
            return _protocol;
        }
        
        /**
         * Determinates the 'search' String value from the HTML DOM.
         */        
        public function get search():String
        {
            if( _search )
            {
                return _search;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _search = getProperty( "document.location.search" );
            
            return _search;
        }
        
        /**
         * Returns the referrer value of the html dom.
         * @return the referrer value of the html dom.
         */
        public function get referrer():String
        {
            if( _referrer )
            {
                return _referrer;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _referrer = getProperty( "document.referrer" );
            
            return _referrer;
        }
        
        /**
         * Returns the title value of the html dom.
         * @return the title value of the html dom.
         */
        public function get title():String
        {
            if( _title )
            {
                return _title;
            }
            
            if( !isAvailable() )
            {
                return null;
            }
            
            _title = getProperty( "document.title" );
            
            return _title;
        }

        /**
         * Returns whether you are in an iframe or not.
         * @return a boolean, true if in an iframe false if not.
         */
        public function get inIframe():Boolean
        {
            if( _inIframe )
            {
                return _inIframe;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

            _inIframe = call( in_iframe_js );
            
            return _inIframe;
        }

        /**
         * Returns a uri object for the parent window when in an iframe
         * @return a boolean, true if in an iframe false if not.
         */
        public function get parentUri():uri
        {
            if( _parentUri )
            {
                return _parentUri;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
				_parentUri = new uri( _referrer )
			}
            
            return _parentUri;
        }

        /**
         * Determinates the 'host' String value from the parent window when in an iframe.
         */
        public function get host():String
        {
            if( _parentHost )
            {
                return _parentHost;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
	        	_parentHost = _parentUri.authority;
			}
            
            return _parentHost;
        }

        /**
         * Determinates the 'location' String value from the parent window when in an iframe.
         */
        public function get parentLocation():String
        {
            if( _parentLocation )
            {
                return _parentLocation;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
	        	_parentLocation = _referrer;
			}
            
            return _parentLocation;
        }

        /**
         * Determinates the 'path' String value from the parent window when in an iframe.
         */
        public function get parentPathname():String
        {
            if( _parentPathname )
            {
                return _parentPathname;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
	        	_parentPathname = _parentUri.path;
			}
            
            return _parentPathname;
        }

        /**
         * Determinates the 'protocol' String value from the parent window when in an iframe.
         */
        public function get parentProtocol():String
        {
            if( _parentProtocol )
            {
                return _parentProtocol;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
	        	_parentProtocol = _parentUri.scheme;
			}
            
            return _parentProtocol;
        }

        /**
         * Determinates the 'query string' String value from the parent window when in an iframe.
         */
        public function get parentSearch():String
        {
            if( _parentSearch )
            {
                return _parentSearch;
            }
            
            if( !isAvailable() )
            {
                return null;
            }

			if (_inIframe)
			{
	        	_parentSearch = _parentUri.queryRaw;
			}
            
            return _parentSearch;
        }
    }
}
