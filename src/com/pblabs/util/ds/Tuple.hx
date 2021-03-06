/*******************************************************************************
 * Hydrax: haXe port of the PushButton Engine
 * Copyright (C) 2010 Dion Amago
 * For more information see http://github.com/dionjwa/Hydrax
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.util.ds;

import com.pblabs.util.ds.Hashable;
import com.pblabs.util.Equalable;
import com.pblabs.util.StringUtil;
import com.pblabs.util.EqualableUtil;

class Tuple <V1, V2> 
    implements Hashable, implements Equalable<Dynamic>
{
    public var v1 (default, null) :V1;
    public var v2 (default, null) :V2;
    
    //TODO: make better.  This is a rather crappy hash function.  
    public static function computeHashCode (v1 :Dynamic, v2 :Dynamic) :Int
    {
        var value :Int = 17;
        value = value * 31 + 
            if (v1 == null) {
                StringUtil.hashCode("" + v1);
            } else 
            if (Std.is(v1, Hashable)) {
                cast(v1, Hashable).hashCode();
            } else if (Std.is(v1, Int)) {
                v1;
            } else {
                StringUtil.hashCode("" + v1);
            }
        value = value * 31 + 
            if (v2 == null) {
                StringUtil.hashCode("" + v2);
            } else if (Std.is(v2, Hashable)) {
                cast(v2, Hashable).hashCode();
            } else if (Std.is(v2, Int)) {
                v2;
            } else {
                StringUtil.hashCode("" + v2);
            }    
        return value;
    }
    
    public function new (v1 :V1, v2 :V2)
    {
        set(v1, v2);
    }
    
    public function hashCode () :Int
    {
        return _hashCode;
    }
    
    public function equals (other :Dynamic) :Bool
    {
        if (!Std.is(other, Tuple)) {
            return false;
        }
        var v :Tuple <V1, V2> = cast(other);
        return EqualableUtil.equals(v1, v.v1) && EqualableUtil.equals(v2, v.v2);
    }
    
    public function toString () :String
    {
        return "[" + v1 + ", " + v2 + "]";
    }
    
    //Bad idea?
    public function clear () :Void
    {
        v1 = null;
        v2 = null;
        _hashCode = 0;
    }
    
    //Bad idea?  It would fuck up Tuple map keys
    public function set (v1 :V1, v2 :V2) :Void
    {
        this.v1 = v1;
        this.v2 = v2;
        _hashCode = computeHashCode(v1, v2);
    }

    var _hashCode :Int;
}


