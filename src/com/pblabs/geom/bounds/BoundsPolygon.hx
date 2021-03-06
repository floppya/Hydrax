/*******************************************************************************
 * Hydrax: haXe port of the PushButton Engine
 * Copyright (C) 2010 Dion Amago
 * For more information see http://github.com/dionjwa/Hydrax
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.geom.bounds;

import com.pblabs.engine.debug.Log;

import com.pblabs.util.MathUtil;

import com.pblabs.geom.Circle;
import com.pblabs.geom.LineSegment;
import com.pblabs.geom.Polygon;
import com.pblabs.geom.Rectangle;
import com.pblabs.geom.Vector2;
import com.pblabs.geom.bounds.AbstractBounds;
import com.pblabs.geom.bounds.BoundsForwarding;
import com.pblabs.geom.bounds.BoundsLine;
import com.pblabs.geom.bounds.BoundsPoint;
import com.pblabs.geom.bounds.BoundsUtil;
import com.pblabs.geom.bounds.IBounds;
import com.pblabs.util.ReflectUtil;

using Lambda;

using com.pblabs.geom.CircleUtil;
using com.pblabs.geom.PolygonTools;
using com.pblabs.geom.VectorTools;

class BoundsPolygon extends AbstractBounds<BoundsPolygon>
{
    /** Don't modify this outside of the Bounds.  The cached bounds will be wrong*/   
    public var polygon(get_polygon, null) : com.pblabs.geom.Polygon;
    
    public function new (polygon :Polygon)
    {
        super();
        set_polygon(polygon);
    }
    
    inline function set_polygon (p :Polygon) :Void
    {
        _polygon = p;
        _boundsRect = _polygon.boundingBox;
        _boundsCircle = _polygon.boundingCircle;
    }

    override function get_center ():Vector2
    {
        return _boundsCircle.center;
    }
    
    override function set_center (val :Vector2) :Vector2
    {
        var c = get_center();
        var dx = val.x - c.x;
        var dy = val.y - c.y;
        _polygon.translateLocal(dx, dy);
        _boundsCircle.center.x += dx;
        _boundsCircle.center.y += dy;
        _boundsRect.x += dx;
        _boundsRect.y += dy;
        return val;
    }

    inline function get_polygon () :com.pblabs.geom.Polygon
    {
        return _polygon;
    }

    override public function containsBounds (b :IBounds<Dynamic>) :Bool
    {
        throw "Not implemented";
        // if (Std.is(b, BoundsPoint)) {
        //     return contains(cast(b, BoundsPoint).center);
        // } else if (Std.is(b, BoundsLine)) {
        //     var line = cast(b, BoundsLine).lineSegment;
        //     return contains(line.a) && contains(line.b);
        // } else if (Std.is(b, BoundsPolygon)) {
        //     return polygon.contains(cast(b, BoundsPolygon).polygon);
        // }
        // throw "containsBounds not implemented between " + ReflectUtil.tinyClassName(this) +
        //     " and " + ReflectUtil.tinyClassName(b);
        return false;
    }

    public function toString () :String
    {
        return _polygon.toString();
    }

    override public function clone () :BoundsPolygon
    {
        return new BoundsPolygon(_polygon.clone());
    }

    override public function containsPoint (v :Vector2) :Bool
    {
        if (!_polygon.boundingBox.contains(v.x, v.y)) {
            return false;
        }
        return _polygon.isPointInside(v) || _polygon.isPointOnEdge(v);
    }

    override public function distance (b :IBounds<Dynamic>) :Float
    {
        if (Std.is(b, BoundsForwarding)) {
            return distance(cast(b, BoundsForwarding<Dynamic>).getForwarded()); 
        }
        
        if (Std.is(b, BoundsPoint)) {
            return BoundsUtil.distancePointPolygon(cast(b), this);
        } else if (Std.is(b, BoundsPolygon)) {
            return BoundsUtil.distancePolygonPolygon(cast(b), this);
        } 
        // else if (Std.is( b, BoundsLine)) {
        //     return _polygon.distanceToLine(cast(b, BoundsLine).lineSegment);
        // }
        throw "Not implemented between " + ReflectUtil.tinyClassName(this) + " and " + ReflectUtil.tinyClassName(b);
        return Math.NaN;
    }
    
    override public function isWithinDistance(b :IBounds<Dynamic>, d :Float) :Bool
    {
        if (Std.is(b, BoundsForwarding)) {
            return isWithinDistance(cast(b, BoundsForwarding<Dynamic>).getForwarded(), d); 
        }
        
        if (Std.is(b, BoundsPoint)) {
            return BoundsUtil.isWithinDistancePointPolygon(cast(b), this, d);
        } else if (Std.is(b, BoundsPolygon)) {
            return BoundsUtil.isWithinDistancePolygonPolygon(cast(b), this, d);
        }
        // else if (Std.is( b, BoundsLine)) {
        //     return _polygon.distanceToLine(cast(b, BoundsLine).lineSegment);
        // }
        throw "Not implemented between " + ReflectUtil.tinyClassName(this) + " and " + ReflectUtil.tinyClassName(b);
        return false;
    }

    override public function distanceToPoint (v :Vector2) :Float
    {
        return _polygon.distToPolygonEdge(v);
    }

    override function get_boundingCircle () :Circle
    {
        return _boundsCircle;
    }
    
    override function get_boundingRect () :Rectangle
    {
        return _boundsRect;
    }

    var _polygon :Polygon;
    // static var TEMP_VECTOR :Vector2 = new Vector2(); 
}


