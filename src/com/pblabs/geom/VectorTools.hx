/*******************************************************************************
 * Hydrax: haXe port of the PushButton Engine
 * Copyright (C) 2010 Dion Amago
 * For more information see http://github.com/dionjwa/Hydrax
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.geom;

import com.pblabs.engine.debug.Log;

import com.pblabs.util.ds.Map;
import com.pblabs.util.ds.Maps;
import com.pblabs.geom.Vector2;

using Lambda;

using com.pblabs.geom.Geometry;
/**
 * Use "using com.pblabs.geom.VectorTools" for code 
 * completion access to these functions.
 *
 */
class VectorTools
 {
    //Multiply by these numbers to get your result.
    //EG: angleInRadians = 30 * DEG_TO_RAD;
    // public function new() { }
    
    //Multiply by these numbers to get your result.
    //EG: angleInRadians = 30 * DEG_TO_RAD;
    public static inline var RAD_TO_DEG :Float = (180 / Math.PI); //57.29577951;
    public static inline var DEG_TO_RAD :Float = (Math.PI / 180); //0.017453293;
    public static inline var ZERO :Vector2 = new Vector2(); //0.017453293;
    public static inline var PI2 :Float = Math.PI * 2;

    inline public static function distance (a :Vector2, b :Vector2) :Float
    {
        return Math.sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y));
    }
    
    inline public static function distanceSq (a :Vector2, b :Vector2) :Float
    {
        return  (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y);
    }
    
    //Returns the angle between two points
    public static function calcAngle (p1 :Vector2, p2 :Vector2) :Float
    {
        var angle = Math.atan((p2.y - p1.y) / (p2.x - p1.x));

        //if it is in the first quadrant
        if (p2.y < p1.y && p2.x > p1.x) {
            return angle;
        }
        //if its in the 2nd or 3rd quadrant
        if ((p2.y < p1.y && p2.x < p1.x) || (p2.y > p1.y && p2.x < p1.x)) {
            return angle + Math.PI;
        }
        //it must be in the 4th quadrant so:
        return angle + Math.PI * 2;
    }

    inline public static function addLocalPolarVector (v :Vector2, rad :Float, length :Float) :Vector2
    {
        var polar = VectorTools.angleToVector2(rad, length);
        v.addLocal(polar);
        return v;
    }
    
    /**
     * Creates a Vector2 of magnitude 'len' that has been rotated about the origin by 'radians'.
     */
    public static inline function angleToVector2 (radians :Float, ?len :Float = 1) :Vector2
    {
       // we use the unit vector (1, 0)

        return new Vector2(
            Math.cos(radians) * len,   // == len * (cos(theta)*x - sin(theta)*y)
            Math.sin(radians) * len);  // == len * (sin(theta)*x + cos(theta)*y)
    }

    /**
     * Returns the angle (radians) from v1 to v2.
     */
    inline public static function angleTo (v1 :Vector2, v2 :Vector2) :Float
    {
        return getAngle(v1.x, v1.y, v2.x, v2.y);
    }

    inline public static function getAngle (x1 :Float, y1 :Float, x2 :Float, y2 :Float) :Float
    {
        var angle = Math.atan2(y2 - y1, x2 - x1);
        return (angle >= 0 ? angle : angle + PI2);
    }
    
    inline public static function getMidpoint (v1 :Vector2, v2 :Vector2) :Vector2
    {
        return new Vector2(v1.x + (v2.x - v1.x) / 2, v1.y + (v2.y - v1.y) / 2);
    }
    
    inline public static function lengthSq (v1 :Vector2) :Float
    {
        return v1.x*v1.x + v1.y*v1.y;
    }

      //origin means original starting radian, dest destination radian around a circle
    /**
     * Determines which direction a point should rotate to match rotation the quickest
     * @param objectRotationRadians The object you would like to rotate
     * @param radianBetween the angle from the object to the point you want to rotate to
     * @return -1 if left, 0 if facing, 1 if right
     *
     */
    public static function getSmallestRotationDirection(objectRotationRadians:Float,
        radianBetween:Float, ?errorRadians:Float = 0):Float
    {
        objectRotationRadians = objectRotationRadians.normalizeRadians();
        radianBetween = radianBetween.normalizeRadians();

        radianBetween += -objectRotationRadians;
        radianBetween = radianBetween.normalizeRadians();
        objectRotationRadians = 0;
        if(radianBetween < -errorRadians)
        {
            return -1;
        }
        else if(radianBetween > errorRadians)
        {
            return 1;
        }
        return 0;
    }

    /**
     * Normalizes an angle in radians to occupy the [-pi, pi) range.
     * @param radian
     * @return
     */
    inline public static function simplifyRadian (radian :Float) :Float
    {
        radian = radian.normalizeRadians();

        if (radian > Math.PI) {
            return radian - PI2;
        } else {
            return radian;
        }

//        if(radian > Math.PI || radian < -Math.PI)
//        {
//            var newRadian:Number;
//            newRadian = radian - int(radian / PI2) * PI2;
//            if(radian > 0)
//            {
//                if(newRadian < Math.PI)
//                {
//                    return newRadian;
//                }
//                else
//                {
//                    newRadian =- (PI2 - newRadian);
//                    return newRadian;
//                }
//            }
//            else
//            {
//                if(newRadian > -Math.PI)
//                {
//                    return newRadian;
//                }
//                else
//                {
//                    newRadian = ((PI2) + newRadian);
//                    return newRadian;
//                }
//            }
//        }
//        return radian;
    }

    /**
     * The smallest difference between two angles with the right sign and clamped (-Pi, Pi)
     */
    inline public static function differenceAngles (angle1 :Float, angle2 :Float) :Float
    {
        var diff = angle1 - angle2;
        if( diff > Math.PI) {
            diff = -PI2 + diff;
        }
        if( diff < -Math.PI) {
            diff = PI2 + diff;
        }
        return -diff;
    }
    
    #if flash
    /**
     * Converts Point p to a Vector2.
     */
    public static function toVector2 (p :flash.geom.Point) :Vector2
    {
        return new Vector2(p.x, p.y);
    }
    
    public static function toPoint (v :Vector2) :flash.geom.Point
    {
        return new flash.geom.Point(v.x, v.y);
    }
    #end
}


