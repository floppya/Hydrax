/*******************************************************************************
 * Hydrax: haXe port of the PushButton Engine
 * Copyright (C) 2010 Dion Amago
 * For more information see http://github.com/dionjwa/Hydrax
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.util;

import com.pblabs.engine.core.IEntityComponent;
import com.pblabs.engine.core.PropertyReference;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
/**
 * Encapsulated a variable with a signaller: when the variable is
 * modified, listeners are notified.  This reduces clutter in classes 
 * from the getter/setter property functions.
 *
 * The Editor correctly handles SignallingVar fields.
 */
class SignallingVar<T>
{
    public var signaller (default, null) :Signaler<T>;
    public var value (get_value, set_value) :T;
    
    public static function checkForSignallingVar<V> (prop :String, c :IEntityComponent, fieldName :String) :PropertyReference<V>
    {
        if (Std.is(Reflect.field(c, fieldName), SignallingVar)) {
            return new PropertyReference(prop + ".value");
        } else {
            return new PropertyReference(prop);
        }
    }
    
    public function new (initialValue :T)
    {
        signaller = new DirectSignaler(this);
        _value = initialValue;
    }
    
    public function clear () :Void
    {
        signaller.unbindAll();
        _value = null;
    }
    
    inline function get_value () :T
    {
        return _value;
    }
    
    inline function set_value (val :T) :T
    {
        _value = val;
        signaller.dispatch(_value);
        return val;
    }
    var _value :T;
}


