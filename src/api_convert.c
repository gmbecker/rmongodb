/* Reduced code to convert BSON to R list without any type conversion maddness. Jeroen Ooms (2014) */

#include <R.h>
#include "api_bson.h"
#include "utility.h"
#include <stdbool.h>

typedef bson bson_buffer;

SEXP ConvertValue(bson_iterator* iter);
SEXP ConvertObject(bson* b, bool is_namedlist);
SEXP R_ConvertObject(SEXP x);

SEXP R_ConvertObject(SEXP x) {
    bson* b = _checkBSON(x);
    return ConvertObject(b, true);
}


SEXP ConvertValue(bson_iterator* iter){
    bson sub;
    bson_type sub_type = bson_iterator_type(iter);
    switch (sub_type) {
        case BSON_INT:
            return ScalarInteger(bson_iterator_int(iter));
        case BSON_DOUBLE:
            return ScalarReal(bson_iterator_double(iter));
        case BSON_STRING:
            return mkString(bson_iterator_string(iter));
        case BSON_BOOL:
            return ScalarLogical(bson_iterator_bool(iter));
        case BSON_LONG:
            return ScalarReal(bson_iterator_long(iter));
        case BSON_DATE:
            return ScalarReal(bson_iterator_date(iter)/1000);
        case BSON_ARRAY:
            bson_iterator_subobject(iter, &sub);
            return ConvertObject(&sub, false);
        case BSON_OBJECT:
            bson_iterator_subobject(iter, &sub);
            return ConvertObject(&sub, true);
        case BSON_BINDATA: 
        case BSON_OID:            
        case BSON_NULL:
        case BSON_TIMESTAMP:
        case BSON_REGEX:
        case BSON_UNDEFINED:
        case BSON_SYMBOL:
        case BSON_CODEWSCOPE:
        case BSON_CODE:
            return _mongo_bson_value(iter);
        default:
            error("Unhandled BSON type %d\n", sub_type);
    }
}

SEXP ConvertObject(bson* b, bool is_namedlist) {
    SEXP names, ret;
    bson_iterator iter;
    bson_type sub_type;
    
    //iterate over array to get size
    int count = 0;
    bson_iterator_init(&iter, b);    
    while(bson_iterator_next(&iter)){
      count++;
    }
    
    //reset iterator  
    bson_iterator_init(&iter, b);
    PROTECT(ret = allocVector(VECSXP, count));
    PROTECT(names = allocVector(STRSXP, count));      
    for (int i = 0; (sub_type = bson_iterator_next(&iter)); i++) {
        SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
        SET_VECTOR_ELT(ret, i, ConvertValue(&iter));
    }
    
    //only add names for BSON object
    if(is_namedlist){
      setAttrib(ret, R_NamesSymbol, names);      
    }
    
    UNPROTECT(2);
    return ret;
}
