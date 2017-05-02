%module(package="com.openaaa", jniclassname="JNI",
        docstring="Bindings for AAA library") "Native"

%javaconst(1);

%include "ctor.i"
%include "typemaps.i"
%include "cpointer.i"

%rename(AAA) aaa;
%rename(Option) aaa_opt_e;
%rename(EndpointType) aaa_endpoint;

%rename("%(strip:[ENDPOINT_])s") "";

%nodefaultctor aaa;
%ignore aaa_new;
%ignore aaa_free;
%ignore aaa_bind;
%ignore aaa_commit;
%ignore aaa_reset;
%ignore aaa_attr_set;
%ignore aaa_attr_get;

%{
struct aaa {} ;
#include "lib.h"
#include "jnu.h"
%}

struct aaa { 
        %extend {
                aaa(int type, int flags) { 
                        struct aaa *aaa = aaa_new(type, flags); 
                        return (struct aaa*)aaa;
                }
		int _bind(int type, const char *id) {
			return aaa_bind(self, type, id);
		}
		int _commit() {
			return aaa_commit(self);
		}
		void _reset() {
			aaa_reset(self);
		}
	
		int _set(const char *key, const char *val) {
			return aaa_attr_set(self, key, val);
		}
 		const char * _get(const char *key) {
			return aaa_attr_get(self, key);
		}

                ~aaa() { 
                        aaa_free((struct aaa*)self);
                }
        }

};

%include "../lib.h"
