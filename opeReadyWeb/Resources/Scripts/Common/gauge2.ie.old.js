﻿/*
* Bindows Gauges Library version 1.1beta3
* http://www.bindows.net/
* Copyright © 2003-2010 MB Technologies
*
* Bindows(TM) and the Bindows Gauges Library belong to MB Technologies (Georgia, USA). All rights reserved.
*
* The package is provided FREE of charge, without any warranty and without any commitment for support.
*/

function BiVmlComponent() {
    if (_biInPrototype) return;
    BiComponent.call(this);
}
_p = _biExtend(BiVmlComponent, BiComponent, "BiVmlComponent");
_p._tagName = "v:group";
_p.setViewBox = function (nMinX, nMinY, nWidth, nHeight) {
    this.setHtmlProperty("coordsize", "" + nWidth + " " + nHeight);
    this.setHtmlProperty("coordorigin", "" + nMinX + " " + nMinY);
};
_p.createVmlElement = function (name) {
    if (!document.namespaces["v"]) document.namespaces.add("v", "urn:schemas-microsoft-com:vml");
    return this._document.createElement("v:" + name);
};

function BiGauge2() {
    if (_biInPrototype) return;
    BiComponent.call(this);
    this._gauge2Group = new BiGauge2Group;
    BiComponent.prototype.add.call(this, this._gauge2Group);
    this._gauge2Group.setLeft(0);
    this._gauge2Group.setRight(0);
    this._gauge2Group.setTop(0);
    this._gauge2Group.setBottom(0);
    this.setCoordWidth(1000);
    this.setCoordHeight(1000);
};
_p = _biExtend(BiGauge2, BiComponent, "BiGauge2");
BiGauge2._addNs = function (d) {
    if (d.namespaces != undefined) {
        if (!d.namespaces["v"] || d.namespaces["v"] == undefined) {
            d.namespaces.add("v", "urn:schemas-microsoft-com:vml");
        }
    }
};
BiGauge2.setViewBox = function (o, nX, nY, nWidth, nHeight) {
    o.setHtmlProperty("coordsize", "" + nWidth + " " + nHeight);
    o.setHtmlProperty("coordorigin", "" + nX + " " + nY);
};
BiGauge2.addProperty("coordWidth", BiAccessType.READ_WRITE);
BiGauge2.addProperty("coordHeight", BiAccessType.READ_WRITE);
_p.add = function (oChild) {
    oChild._gaugeComponent = this;
    this._gauge2Group.add(oChild);
};
_p.getClientWidth = function () {
    return BiComponent.prototype.getClientWidth.call(this) || this._width;
};
_p.getClientHeight = function () {
    return BiComponent.prototype.getClientHeight.call(this) || this._height;
};
_p._create = function (oDocument) {
    BiComponent.prototype._create.call(this, oDocument);
    BiGauge2._addNs(this._document);
    var el = this._document.createElement("div");
    el.setAttribute("id", "testLabelSize");
    el.style.visibility = "hidden";
    el.style.height = "1px";
    el.style.width = "1px";
    el.style.position = "absolute";
    this._element.appendChild(el);
};
_p.layoutAllChildren = function () {
    BiGauge2.setViewBox(this._gauge2Group, 0, 0, this.getCoordWidth(), this.getCoordHeight());
    BiComponent.prototype.layoutAllChildren.call(this);
};

function BiGauge2Group() {
    if (_biInPrototype) return;
    BiComponent.call(this);
};
_p = _biExtend(BiGauge2Group, BiComponent, "BiGauge2Group");
_p._tagName = "v:group";
_p.getClientWidth = function () {
    return this._parent.getClientWidth();
};
_p.getClientHeight = function () {
    return this._parent.getClientHeight();
};

function BiGauge2Component() {
    if (_biInPrototype) return;
    BiComponent.call(this);
    this.setHtmlProperty("stroked", "f");
}
_p = _biExtend(BiGauge2Component, BiComponent, "BiGauge2Component");
_p._addHtmlElementToParent = function (oParent, oBefore) {
    if (this._created) {
        this._setHtmlProperties();
    }
    BiComponent.prototype._addHtmlElementToParent.call(this, oParent, oBefore);
};
BiGauge2Component.addProperty("filler", BiAccessType.READ_WRITE);
BiGauge2Component.addProperty("centerX", BiAccessType.READ);
_p.setCenterX = function (nCenterX) {
    this._centerX = nCenterX;
    this.setLeft(nCenterX - (this._width || 0) / 2);
};
BiGauge2Component.addProperty("centerY", BiAccessType.READ);
_p.setCenterY = function (nCenterY) {
    this._centerY = nCenterY;
    this.setTop(nCenterY - (this._height || 0) / 2);
};
_p.add = function (oChild) {
    BiComponent.prototype.add.call(this, oChild);
};
_p.setFiller = function (oFiller) {
    if (this._filler) this._filler.dispose();
    this._filler = oFiller;
    oFiller.applyFiller(this);
};
_p.setWidth = function (nWidth) {
    BiComponent.prototype.setWidth.call(this, nWidth);
    this.setCenterX(this._centerX);
};
_p.setHeight = function (nHeight) {
    BiComponent.prototype.setHeight.call(this, nHeight);
    this.setCenterY(this._centerY);
};
_p.getWidth = function () {
    return this._width;
};
_p.getHeight = function () {
    return this._height;
};
_p.setPosition = function (cX, cY) {
    this.setCenterY(cY);
    this.setCenterX(cX);
};
_p.setSize = function (w, h) {
    this.setWidth(w);
    this.setHeight(h);
};
BiGauge2Component.addProperty("stroke", BiAccessType.READ_WRITE);
BiGauge2Component.addProperty("strokeWidth", BiAccessType.READ_WRITE);
_p.setStroke = function (sStroke) {
    this._stroke = sStroke;
    this.setHtmlProperty("stroked", (sStroke && sStroke.length > 0) ? "True" : "False");
    this.setHtmlProperty("strokecolor", sStroke);
};
_p.setStrokeWidth = function (nStrokeWidth) {
    this._strokeWidth = nStrokeWidth;
    this.setHtmlProperty("stroked", (nStrokeWidth && nStrokeWidth > 0) ? "True" : "False");
    this.setHtmlProperty("strokeweight", nStrokeWidth * this._getScaleFactor());
};
_p._getGaugeComponent = function () {
    if (!this._gaugeComponent) {
        var p = this._parent;
        while (p._tagName.toUpperCase() != "DIV") p = p._parent;
        this._gaugeComponent = p;
    }
    return this._gaugeComponent;
};
_p._getScaleFactor = function () {
    if (!this._parent) return 0;
    var g = this._getGaugeComponent();
    return Math.min(g.getClientWidth()/ g.getCoordWidth(), g.getClientHeight() / g.getCoordHeight());
};
_p._getScaleHeight = function () {
    if (!this._parent) return 0;
    return this._getGaugeComponent().getClientHeight();
};
_p.layoutComponent = function () {
    BiComponent.prototype.layoutComponent.call(this);
    this._resizeNonScalable();
};
_p._resizeNonScalable = function () {
    this.setStrokeWidth(this._strokeWidth);
};

function BiAbstractGauge2Border(sStroke) {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
    if (sStroke) this.setStroke(sStroke);
    if (BiBrowserCheck.moz) this.setStrokeWidth(0);
};
_p = _biExtend(BiAbstractGauge2Border, BiGauge2Component, "BiAbstractGauge2Border");

function BiGauge2ArcBorder() {
    if (_biInPrototype) return;
    BiComponent.call(this);
};
_p = _biExtend(BiGauge2ArcBorder, BiAbstractGauge2Border, "BiGauge2ArcBorder");
_p._tagName = "v:shape";
_p._pie = false;
BiGauge2ArcBorder.addProperty("startAngle", BiAccessType.READ_WRITE);
BiGauge2ArcBorder.addProperty("endAngle", BiAccessType.READ_WRITE);
BiGauge2ArcBorder.addProperty("pie", BiAccessType.READ_WRITE);
_p.layoutComponent = function () {
    BiAbstractGauge2Border.prototype.layoutComponent.call(this);
    var r = 1000;
    var a0 = this._startAngle / 180 * Math.PI;
    var a1 = this._endAngle / 180 * Math.PI;
    var el = this._element;
    el.coordorigin = -r + " " + -r;
    el.coordsize = 2 * r + " " + 2 * r;
    var p0 = Math.round(Math.sin(a0) * r) + " " + Math.round(-Math.cos(a0) * r);
    var p1 = Math.round(Math.sin(a1) * r) + " " + Math.round(-Math.cos(a1) * r);
    var d = this._pie ? ["m ", p0, " wr ", -r, " ", -r, " ", r, " ", r, " ", p0, " ", p1, " l 0 0 ", p0] : ["m ", p0, " wr ", -r, " ", -r, " ", r, " ", r, " ", p0, " ", p1, " l ", p0];
    el.path = d.join("");
};

function BiGauge2CircularBorder() {
    if (_biInPrototype) return;
    BiComponent.call(this);
};
_p = _biExtend(BiGauge2CircularBorder, BiAbstractGauge2Border, "BiGauge2CircularBorder");
_p._tagName = "v:oval";

function BiGauge2RectangularBorder() {
    if (_biInPrototype) return;
    BiAbstractGauge2Border.call(this);
    this.setArcSize(0);
};
_p = _biExtend(BiGauge2RectangularBorder, BiAbstractGauge2Border, "BiGauge2RectangularBorder");
_p._tagName = "v:roundrect";
BiGauge2RectangularBorder.addProperty("arcSize", BiAccessType.READ_WRITE);
_p.setArcSize = function (nArcSize) {
    this._arcSize = nArcSize;
    this.setHtmlProperty("arcsize", nArcSize + "%");
};
BiGauge2RectangularBorder.addProperty("angle", BiAccessType.READ_WRITE);
_p.setAngle = function (n) {
    this._angle = n;
    this.setStyleProperty("rotation", n + "deg");
};

function BiGauge2ImageBorder() {
    if (_biInPrototype) return;
    BiAbstractGauge2Border.call(this);
    this.setHtmlProperty("preserveAspectRatio", "none");
};
_p = _biExtend(BiGauge2ImageBorder, BiAbstractGauge2Border, "BiGauge2ImageBorder");
_p._tagName = "v:image";
BiGauge2ImageBorder.addProperty("uri", BiAccessType.READ);
_p.setUri = function (oUri) {
    if (oUri != null && !(oUri instanceof BiUri)) {
        oUri = new BiUri(application.getAdfPath(), oUri);
    }
    var sUri = String(oUri);
    if (String(this._uri) != sUri) {
        this._uri = oUri;
        this.setHtmlProperty("src", sUri);
    }
};

function BiAbstractGauge2Filler() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
};
_p = _biExtend(BiAbstractGauge2Filler, BiGauge2Component, "BiAbstractGauge2Filler");
_p._tagName = "";
_p.applyFiller = function (oGroupChild) { };

function BiGauge2PlainColorFiller(sColor) {
    if (_biInPrototype) return;
    BiComponent.call(this);
    if (sColor) this.setColor(sColor);
};
_p = _biExtend(BiGauge2PlainColorFiller, BiAbstractGauge2Filler, "BiGauge2PlainColorFiller");
_p._tagName = "";
BiGauge2PlainColorFiller.addProperty("color", BiAccessType.READ_WRITE);
_p.applyFiller = function (oGroupChild) {
    oGroupChild.setHtmlProperty("fillcolor", (this._color ? this._color : "none"));
};

function BiAbstractGauge2GradientFiller() {
    if (_biInPrototype) return;
    BiAbstractGauge2Filler.call(this);
    if (BiBrowserCheck.features.hasSvg) {
        this._stop1 = BiSvgComponent.newSvgComponent("stop");
        this._stop2 = BiSvgComponent.newSvgComponent("stop");
        this._stop1.setHtmlProperty("offset", "0%");
        this._stop2.setHtmlProperty("offset", "100%");
        this.add(this._stop1);
        this.add(this._stop2);
    }
};
_p = _biExtend(BiAbstractGauge2GradientFiller, BiAbstractGauge2Filler, "BiAbstractGauge2GradientFiller");
_p._color1 = "black";
_p._color2 = "white";
_p._opacity1 = 1;
_p._opacity2 = 1;
_p._xpos = 50;
_p._ypos = 50;
BiAbstractGauge2GradientFiller.addProperty("color1", BiAccessType.READ_WRITE);
BiAbstractGauge2GradientFiller.addProperty("color2", BiAccessType.READ_WRITE);
BiAbstractGauge2GradientFiller.addProperty("opacity1", BiAccessType.READ_WRITE);
BiAbstractGauge2GradientFiller.addProperty("opacity2", BiAccessType.READ_WRITE);
BiAbstractGauge2GradientFiller.addProperty("xpos", BiAccessType.READ_WRITE);
BiAbstractGauge2GradientFiller.addProperty("ypos", BiAccessType.READ_WRITE);

function BiGauge2RadialGradientFiller() {
    if (_biInPrototype) return;
    BiAbstractGauge2GradientFiller.call(this);
};
_p = _biExtend(BiGauge2RadialGradientFiller, BiAbstractGauge2GradientFiller, "BiGauge2RadialGradientFiller");
_p._tagName = "v:fill";
_p._used = false;
_p.setColor1 = function (sCol) {
    this._color1 = sCol;
    if (this._parent) this._parent.setHtmlProperty("fillcolor", sCol);
};
_p.setColor2 = function (sCol) {
    this._color2 = sCol;
    this.setHtmlProperty("color2", sCol);
};
_p.setOpacity1 = function (n) {
    this._opacity1 = n;
    this.setHtmlProperty("opacity", n);
};
_p.setOpacity2 = function (n) {
    this._opacity2 = n;
    this.setHtmlProperty("opacity2", n);
};
_p.setXpos = function (n) {
    this._xpos = n;
    this.setHtmlProperty("focusposition", this.getXpos() + "%," + this.getYpos() + "%");
};
_p.setYpos = function (n) {
    this._ypos = n;
    this.setHtmlProperty("focusposition", this.getXpos() + "%," + this.getYpos() + "%");
};
_p.applyFiller = function (oGroupChild) {
    if (!this._used) {
        oGroupChild.setHtmlProperty("fillcolor", this.getColor1());
        this.setHtmlProperty("color2", this.getColor2());
        this.setHtmlProperty("opacity", this.getOpacity1());
        this.setHtmlProperty("opacity2", this.getOpacity2());
        this.setHtmlProperty("focus", "100%");
        this.setHtmlProperty("focusposition", this.getXpos() + "%," + this.getYpos() + "%");
        this.setHtmlProperty("type", "gradientRadial");
        this.setHtmlProperty("method", "None");
        oGroupChild.add(this);
        this._used = true;
    }
};

function BiGauge2RingGradientFiller() {
    if (_biInPrototype) return;
    BiAbstractGauge2GradientFiller.call(this);
};
_p = _biExtend(BiGauge2RingGradientFiller, BiAbstractGauge2GradientFiller, "BiGauge2RingGradientFiller");
_p._tagName = "v:fill";
_p._used = false;
BiAbstractGauge2GradientFiller.addProperty("highlightCenter", BiAccessType.READ_WRITE);
_p._highLightCenter = 50;
BiAbstractGauge2GradientFiller.addProperty("thickness", BiAccessType.READ_WRITE);
_p._thickness = 10;
_p.setColor1 = function (sCol) {
    this._color1 = sCol;
    if (this._parent) this._parent.setHtmlProperty("fillcolor", sCol);
};
_p.setColor2 = function (sCol) {
    this._color2 = sCol;
    this.setHtmlProperty("color2", sCol);
};
_p.setOpacity1 = function (n) {
    this._opacity1 = n;
    this.setHtmlProperty("opacity", n);
};
_p.setOpacity2 = function (n) {
    this._opacity2 = n;
    this.setHtmlProperty("opacity2", n);
};
_p.setXpos = function (n) {
    this._xpos = n;
    if (this._created) this._calculateFocus();
};
_p.setYpos = function (n) {
    this._ypos = n;
    if (this._created) this._calculateFocus();
};
_p.setThickness = function (n) {
    this._thickness = n;
    if (this._created) this._calculateFocus();
};
_p.setHighlightCenter = function (n) {
    this._highlightCenter = n;
    if (this._created) this._calculateFocus();
};
_p._calculateFocus = function () {
    var x = this._xpos - 50 + this._thickness;
    var y = this._ypos - 50 + this._thickness;
    this.setHtmlProperty("focus", this._highlightCenter + "%");
    this.setHtmlProperty("focusposition", x + "%," + y + "%");
    var focusSize = 100 - this._thickness * 2;
    this.setHtmlProperty("focussize", focusSize + "%," + focusSize + "%");
};
_p.applyFiller = function (oGroupChild) {
    if (!this._used) {
        oGroupChild.setHtmlProperty("fillcolor", this.getColor1());
        this.setHtmlProperty("color2", this.getColor2());
        this.setHtmlProperty("opacity", this.getOpacity1());
        this.setHtmlProperty("opacity2", this.getOpacity2());
        this._calculateFocus();
        this.setHtmlProperty("type", "gradientRadial");
        this.setHtmlProperty("method", "none");
        oGroupChild.add(this);
        this._used = true;
    }
};

function BiGauge2LinearGradientFiller() {
    if (_biInPrototype) return;
    BiAbstractGauge2GradientFiller.call(this);
};
_p = _biExtend(BiGauge2LinearGradientFiller, BiAbstractGauge2GradientFiller, "BiGauge2LinearGradientFiller");
_p._angle = 0;
BiGauge2LinearGradientFiller.addProperty("angle", BiAccessType.READ_WRITE);
_p._tagName = "v:fill";
_p._used = false;
_p.setColor1 = function (sCol) {
    this._color1 = sCol;
    if (this._parent) this._parent.setHtmlProperty("fillcolor", sCol);
};
_p.setColor2 = function (sCol) {
    this._color2 = sCol;
    this.setHtmlProperty("color2", sCol);
};
_p.setOpacity1 = function (n) {
    this._opacity1 = n;
    this.setHtmlProperty("opacity", n);
};
_p.setOpacity2 = function (n) {
    this._opacity2 = n;
    this.setHtmlProperty("opacity2", n);
};
_p.setAngle = function (n) {
    this._angle = n;
    this.setHtmlProperty("angle", n);
};
_p.applyFiller = function (oGroupChild) {
    if (!this._used) {
        oGroupChild.setHtmlProperty("fillcolor", this.getColor1());
        this.setHtmlProperty("color2", this.getColor2());
        this.setHtmlProperty("opacity", this.getOpacity1());
        this.setHtmlProperty("opacity2", this.getOpacity2());
        this.setHtmlProperty("angle", this.getAngle());
        this.setHtmlProperty("focus", "100%");
        this.setHtmlProperty("type", "gradient");
        oGroupChild.add(this);
        this._used = true;
    }
};

function BiAbstractGauge2Range() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
}
_p = _biExtend(BiAbstractGauge2Range, BiGauge2Component, "BiAbstractGauge2Range");
_p._tagName = "v:group";
_p.setWidth = function (nWidth) {
    this._width = nWidth;
    this.setStyleProperty("width", nWidth);
    BiGauge2.setViewBox(this, 0, 0, this._width, this._height);
    this.setCenterX(this._centerX);
};
_p.setHeight = function (nHeight) {
    this._height = nHeight;
    this.setStyleProperty("height", nHeight);
    BiGauge2.setViewBox(this, 0, 0, this._width, this._height);
    this.setCenterY(this._centerY);
};
_p.layoutComponent = function () {
    BiComponent.prototype.layoutComponent.call(this);
    this.invalidateLayout();
};
_p.layoutAllChildren = function () {
    var w = this.getWidth();
    var h = this.getHeight();
    var cs = this._children;
    var l = cs.length;
    for (var i = 0; i < l; i++) {
        if (!(cs[i] instanceof BiGauge2Label)) cs[i].setPosition(w / 2, h / 2);
        if (cs[i] instanceof BiAbstractGauge2Ticks) cs[i].setSize(w, h);
        if (cs[i] instanceof BiAbstractGauge2Scale) {
            cs[i].setSize(w, h);
        }
        cs[i].layoutComponent();
    }
    this._invalidLayout = false;
};

function BiGauge2RadialRange() {
    if (_biInPrototype) return;
    BiAbstractGauge2Range.call(this);
}
_p = _biExtend(BiGauge2RadialRange, BiAbstractGauge2Range, "BiGauge2RadialRange");
BiGauge2RadialRange.addProperty("startAngle", BiAccessType.READ_WRITE);
BiGauge2RadialRange.addProperty("endAngle", BiAccessType.READ_WRITE);
_p.add = function (oChild) {
    if (oChild instanceof BiGauge2RadialTicks || oChild instanceof BiGauge2RadialScale) {
        oChild.setStartAngle(this._startAngle);
        oChild.setEndAngle(this._endAngle);
    }
    if (oChild._tagName == "v:group") {
        BiGauge2.setViewBox(oChild, 0, 0, this._width, this._height);
    }
    if (oChild instanceof BiAbstractGauge2Border) {
        oChild.setSize(this.getWidth(), this.getHeight());
    }
    BiAbstractGauge2Range.prototype.add.call(this, oChild);
};

function BiGauge2LinearRange() {
    if (_biInPrototype) return;
    BiAbstractGauge2Range.call(this);
};
_p = _biExtend(BiGauge2LinearRange, BiAbstractGauge2Range, "BiGauge2LinearRange");
BiGauge2LinearRange.addProperty("angle", BiAccessType.READ_WRITE);
_p.add = function (oChild) {
    if (oChild._tagName == "v:group") {
        BiGauge2.setViewBox(oChild, 0, 0, this.getWidth(), this.getHeight());
        oChild.setSize(this.getWidth(), this.getHeight());
    }
    BiAbstractGauge2Range.prototype.add.call(this, oChild);
};

function BiAbstractGauge2Ticks() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
    this._ticks = [];
};
_p = _biExtend(BiAbstractGauge2Ticks, BiGauge2Component, "BiAbstractGauge2Ticks");
_p._tagName = "v:group";
BiAbstractGauge2Ticks.addProperty("tickWidth", BiAccessType.READ);
_p.setTickWidth = function (nTickWidth) {
    this._tickWidth = nTickWidth;
    this.setStrokeWidth(nTickWidth);
};
_p.setStrokeWidth = function (nStrokeWidth) {
    this._strokeWidth = nStrokeWidth;
    var l = this._ticks.length;
    for (var i = 0; i < l; i++) {
        var tick = this._ticks[i];
        tick.strokeweight = nStrokeWidth * this._getScaleFactor() + "px";
    }
};
BiAbstractGauge2Ticks.addProperty("tickLength", BiAccessType.READ_WRITE);
BiAbstractGauge2Ticks.addProperty("tickCount", BiAccessType.READ_WRITE);
BiAbstractGauge2Ticks.addProperty("color", BiAccessType.READ_WRITE);
_p.setColor = function (sColor) {
    this._color = sColor;
    this.setHtmlProperty("strokecolor", sColor);
};
BiAbstractGauge2Ticks.addProperty("colors", BiAccessType.READ);
_p.setColors = function (o) {
    if (typeof o == "string") {
        o = o.split(",");
        var l = o.length;
        for (var i = 0; i < l; i++) {
            o[i] = i % 2 ? parseInt(o[i]) : o[i].trim();
        }
    }
    this._colors = o;
};
BiAbstractGauge2Ticks.addProperty("colorFunction", BiAccessType.READ);
_p._colorFunction = _p.getColor;
_p.setColorFunction = function (f) {
    if (typeof f == "string") f = new Function("v", f);
    this._colorFunction = f || _p.getColor;
};
_p._calculateTicks = function () {
    return "";
};
_p.layoutComponent = function () {
    if (!this._ticksCreated) {
        this._createTicks();
        if (this._colors instanceof Array) {
            var cs = this._colors;
            var l = this._ticks.length;
            var ai = 0;
            var j = cs[1] || Number.MAX_VALUE;
            for (var i = 0; i < l; i++, j--) {
                if (j == 0) {
                    ai += 2;
                    j = cs[ai + 1] || Number.MAX_VALUE;
                }
                if (cs[ai]) this._ticks[i].strokecolor = cs[ai];
                else break;
            }
        }
        this._ticksCreated = true;
    }
    BiGauge2Component.prototype.layoutComponent.call(this);
};
_p.dispose = function () {
    if (this._disposed) return;
    BiGauge2Component.prototype.dispose.call(this);
    this.disposeFields("_ticks");
};

function BiGauge2RadialTicks() {
    if (_biInPrototype) return;
    BiAbstractGauge2Ticks.call(this);
};
_p = _biExtend(BiGauge2RadialTicks, BiAbstractGauge2Ticks, "BiGauge2RadialTicks");
BiGauge2RadialTicks.addProperty("startAngle", BiAccessType.READ_WRITE);
BiGauge2RadialTicks.addProperty("endAngle", BiAccessType.READ_WRITE);
BiGauge2RadialTicks.addProperty("radius", BiAccessType.READ_WRITE);
_p._createTicks = function () {
    var tl = this._tickLength;
    var r = this.getRadius();
    var angleStep = (Math.abs(this._endAngle - this._startAngle) / 180 * Math.PI) / (this._tickCount - 1);
    var angle = this._startAngle / 180 * Math.PI;
    var offsetX = (this._parent.getWidth() + tl) / 2;
    var offsetY = (this._parent.getHeight() + tl) / 2;
    var sf = this._getScaleFactor();
    for (var i = 0; i < this._tickCount; i++, angle += angleStep) {
        var el = this._document.createElement("v:shape");
        el.strokecolor = this.getColorFunction().call(this, i);
        el.strokeweight = this._strokeWidth * sf + "px";
        el.stroked = true;
        el.style.width = tl;
        el.style.height = tl;
        el.coordorigin = (tl / 2) + " " + (tl / 2);
        el.coordsize = tl + " " + tl;
        el.style.left = Math.round(offsetX + r * Math.sin(angle));
        el.style.top = Math.round(offsetY - r * Math.cos(angle));
        var x1 = -Math.round(tl / 2 * Math.sin(angle));
        var y1 = Math.round(tl / 2 * Math.cos(angle));
        var x2 = -x1;
        var y2 = -y1;
        el['path'] = ["m", x1, ",", y1, "l", x2, ",", y2, " e"].join(BiString.EMPTY);
        this._element.appendChild(el);
        this._ticks.push(el);
    }
};

function BiGauge2LinearTicks() {
    if (_biInPrototype) return;
    BiAbstractGauge2Ticks.call(this);
};
_p = _biExtend(BiGauge2LinearTicks, BiAbstractGauge2Ticks, "BiGauge2LinearTicks");
BiGauge2LinearTicks.addProperty("angle", BiAccessType.READ_WRITE);
BiGauge2LinearTicks.addProperty("tickSpacing", BiAccessType.READ_WRITE);
_p._createTicks = function () {
    var tl = this._tickLength;
    var n = this._tickCount;
    var r = -((n - 1) / 2 * this._tickSpacing);
    if (this._angle == null) this._angle = this._parent.getAngle();
    var angle = this._angle / 180 * Math.PI;
    var offsetX = (this._parent.getWidth() + tl) / 2;
    var offsetY = (this._parent.getHeight() + tl) / 2;
    var x1 = -Math.round(tl / 2 * Math.cos(angle));
    var y1 = Math.round(tl / 2 * Math.sin(angle));
    var x2 = -x1;
    var y2 = -y1;
    var path = "m" + x1 + "," + y1 + "l" + x2 + "," + y2 + " e";
    var sf = this._getScaleFactor();
    for (var i = 0; i < n; i++) {
        var el = this._document.createElement("v:shape");
        el.strokecolor = this.getColorFunction().call(this, i);
        el.strokeweight = this._strokeWidth * sf + "px";
        el.stroked = true;
        el.style.width = tl;
        el.style.height = tl;
        el.coordorigin = (tl / 2) + " " + (tl / 2);
        el.coordsize = tl + " " + tl;
        el.style.left = Math.round(offsetX + r * Math.sin(angle));
        el.style.top = Math.round(offsetY - r * Math.cos(angle));
        el['path'] = path;
        this._element.appendChild(el);
        this._ticks.push(el);
        r += this._tickSpacing;
    }
};

function BiAbstractGauge2Scale() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
};
_p = _biExtend(BiAbstractGauge2Scale, BiGauge2Component, "BiAbstractGauge2Scale");
_p._tagName = "v:group";
_p._font = BiFont.fromString("Arial 20");
_p._verticalAlign = "middle";
_p._preString = "";
_p._postString = "";
BiAbstractGauge2Scale.addProperty("font", BiAccessType.READ);
_p.setFont = function (o) {
    if (!(o instanceof BiFont)) {
        o = BiFont.fromString("" + o);
    }
    this._font = o;
};
BiAbstractGauge2Scale.addProperty("foreColor", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("labelCount", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("startValue", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("endValue", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("postString", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("preString", BiAccessType.READ_WRITE);
BiAbstractGauge2Scale.addProperty("colors", BiAccessType.READ);
_p.setColors = function (o) {
    if (typeof o == "string") {
        o = o.split(",");
        var l = o.length;
        for (var i = 0; i < l; i++) {
            o[i] = i % 2 ? parseInt(o[i]) : o[i].trim();
        }
    }
    this._colors = o;
};
BiAbstractGauge2Scale.addProperty("colorFunction", BiAccessType.READ);
_p._colorFunction = _p.getForeColor;
_p.setColorFunction = function (f) {
    if (typeof f == "string") f = new Function("v", f);
    this._colorFunction = f || _p.getForeColor;
};
BiAbstractGauge2Scale.addProperty("valueFunction", BiAccessType.READ);
_p._valueFunction = function (v) {
    return v;
};
_p.setValueFunction = function (f) {
    if (typeof f == "string") f = new Function("v", f);
    this._valueFunction = f ||
    function (v) {
        return v;
    };
};
_p._resizeLabels = function () {
    var sf = this._getScaleFactor();
    var s = Math.floor(sf * this._font.getSize());
    if (sf == 0) return;
    for (var i = 0; i < this._labels.length; i++) {
        var w = Math.round(this._labels[i].a != "right" ? this._labels[i].label.innerText.length * s / sf : 6 * s / sf);
        var h = Math.round(s / sf * 1.2);
        this._labels[i].label.style.fontSize = s + "px";
        this._labels[i].label.style.height = h + "px";
        this._labels[i].label.style.width = w + "px";
        if (this._labels[i].a != "right") {
            this._labels[i].label.style.left = Math.round(this._labels[i].x - w / 2);
        } else this._labels[i].label.style.left = Math.round(this._labels[i].x - w);
        if (!this._labels[i]._topIsSet) {
            this._labels[i]._topIsSet = true;
            this._labels[i].label.style.top = Math.round(this._labels[i].y - h / 2);
        }
    }
};
_p.layoutComponent = function () {
    if (!this._labelsCreated) {
        this._createLabels();
        this._labelsCreated = true;
    }
    this._resizeLabels();
    BiGauge2Component.prototype.layoutComponent.call(this);
    this.invalidateLayout();
};

function BiGauge2RadialScale() {
    if (_biInPrototype) return;
    BiAbstractGauge2Scale.call(this);
    this._labels = [];
};
_p = _biExtend(BiGauge2RadialScale, BiAbstractGauge2Scale, "BiGauge2RadialScale");
BiGauge2RadialScale.addProperty("startAngle", BiAccessType.READ_WRITE);
BiGauge2RadialScale.addProperty("endAngle", BiAccessType.READ_WRITE);
BiGauge2RadialScale.addProperty("radius", BiAccessType.READ_WRITE);
_p._valueToAngle = function (n) {
    var v0 = this.getStartValue();
    var v1 = this.getEndValue();
    var a0 = this.getStartAngle();
    var a1 = this.getEndAngle();
    return v0 == v1 ? a0 : a0 + (a1 - a0) * (n - v0) / (v1 - v0);
};
_p._createLabels = function () {
    if (!this._labelCount) return;
    var labels = this._labels = [];
    var i;
    var l = this._labelCount;
    var d = Math.max(1, l - 1);
    var v0 = this.getStartValue();
    var v1 = this.getEndValue();
    for (i = 0; i < l; i++) {
        var v = v0 + (v1 - v0) * (i / d);
        v = Math.round(v * 1000) / 1000;
        labels.push(this._createLabel(v));
    }
    if (this._colors instanceof Array) {
        var cs = this._colors;
        var ai = 0;
        var j = cs[1] || Number.MAX_VALUE;
        for (i = 0; i < l; i++, j--) {
            if (j == 0) {
                ai += 2;
                j = cs[ai + 1] || Number.MAX_VALUE;
            }
            if (cs[ai]) labels[i].label.style.color = cs[ai];
            else break;
        }
    }
};
_p._createLabel = function (nValue) {
    var v = this._valueToAngle(nValue);
    nValue = this.getValueFunction().call(this, nValue);
    var vr = v / 180 * Math.PI;
    var r = this.getRadius();
    var x = r * Math.sin(vr);
    var y = r * Math.cos(vr);
    x = this.getWidth() / 2 + x;
    y = this.getHeight() / 2 - y;
    var el = this._document.createElement("v:shape");
    el.style.textAlign = "center";
    el.style.color = this.getColorFunction().call(this, nValue);
    el.style.fontFamily = this._font.getName();
    el.innerText = this._preString + nValue + this._postString;
    if (this._font.getBold()) el.style.fontWeight = "bold";
    if (this._element.hasChildNodes()) this._element.insertBefore(el, this._element.firstChild);
    else this._element.appendChild(el);
    return {
        label: el,
        x: x,
        y: y,
        a: "center"
    };
};

function BiGauge2LinearScale() {
    if (_biInPrototype) return;
    BiAbstractGauge2Scale.call(this);
};
_p = _biExtend(BiGauge2LinearScale, BiAbstractGauge2Scale, "BiGauge2LinearScale");
BiGauge2LinearScale.addProperty("labelSpacing", BiAccessType.READ_WRITE);
BiGauge2LinearScale.addProperty("labelPosition", BiAccessType.READ_WRITE);
BiGauge2LinearScale.addProperty("angle", BiAccessType.READ_WRITE);
_p._valueToPosition = function (nValue) {
    var r = -((this._labelCount - 1) / 2 * this._labelSpacing);
    return (2 * r) - ((nValue - this.getStartValue()) / (this.getEndValue() - this.getStartValue()) * r * 2 + r);
};
_p._createLabels = function () {
    var n = this._labelCount;
    var labels = [];
    var step = (this.getEndValue() - this.getStartValue()) / (n - 1);
    var v = this.getStartValue();
    var r = -((n - 1) / 2 * this._labelSpacing);
    if (this._angle == null) this._angle = this._parent.getAngle();
    var angle = this._angle / 180 * Math.PI;
    while (v <= this.getEndValue()) {
        v = Math.round(v * 1000) / 1000;
        labels.push(this._createLabel(v, r, angle));
        v += step;
        r += this._labelSpacing;
    }
    this._labels = labels;
    if (this._colors instanceof Array) {
        var cs = this._colors;
        var l = labels.length;
        var ai = 0;
        var j = cs[1] || Number.MAX_VALUE;
        for (var i = 0; i < l; i++, j--) {
            if (j == 0) {
                ai += 2;
                j = cs[ai + 1] || Number.MAX_VALUE;
            }
            if (cs[ai]) labels[i].label.style.color = cs[ai];
            else break;
        }
    }
};
_p._createLabel = function (nValue, r, angle) {
    nValue = this.getValueFunction().call(this, nValue);
    var x = r * Math.sin(angle);
    var y = r * Math.cos(angle);
    var x1 = x + this._labelPosition * Math.cos(angle);
    var y1 = y - this._labelPosition * Math.sin(angle);
    x1 = (this._parent.getWidth() / 2 + x1);
    y1 = (this._parent.getHeight() / 2 - y1);
    var el = this._document.createElement("v:shape");
    el.style.textAlign = (Math.abs(this._angle) > 60 ? "center" : "right");
    el.style.color = this.getColorFunction().call(this, nValue);
    el.innerText = this._preString + nValue + this._postString;
    el.style.fontFamily = this._font.getName();
    if (this._font.getBold()) el.style.fontWeight = "bold";
    if (this._element.hasChildNodes()) this._element.insertBefore(el, this._element.firstChild);
    else this._element.appendChild(el);
    return {
        label: el,
        x: x1,
        y: y1,
        a: (Math.abs(this._angle) > 60 ? "center" : "right")
    };
};

function BiAbstractGauge2Cap() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
    if (BiBrowserCheck.moz) this.setStrokeWidth(0);
};
_p = _biExtend(BiAbstractGauge2Cap, BiGauge2Component, "BiAbstractGauge2Cap");

function BiGauge2BasicCap() {
    if (_biInPrototype) return;
    BiAbstractGauge2Cap.call(this);
};
_p = _biExtend(BiGauge2BasicCap, BiAbstractGauge2Cap, "BiGauge2BasicCap");
_p._tagName = "v:oval";

function BiAbstractGauge2ValueMarker() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
};
_p = _biExtend(BiAbstractGauge2ValueMarker, BiGauge2Component, "BiAbstractGauge2ValueMarker");
BiAbstractGauge2ValueMarker.addProperty("value", BiAccessType.READ_WRITE);

function BiGauge2RadialNeedle() {
    if (_biInPrototype) return;
    BiAbstractGauge2ValueMarker.call(this);
};
_p = _biExtend(BiGauge2RadialNeedle, BiAbstractGauge2ValueMarker, "BiGauge2RadialNeedle");
_p._innerRadius = 0;
_p._innerWidth = 10;
_p._outerWidth = 0;
BiGauge2RadialNeedle.addProperty("outerRadius", BiAccessType.READ_WRITE);
BiGauge2RadialNeedle.addProperty("innerRadius", BiAccessType.READ_WRITE);
BiGauge2RadialNeedle.addProperty("innerWidth", BiAccessType.READ_WRITE);
BiGauge2RadialNeedle.addProperty("outerWidth", BiAccessType.READ_WRITE);
_p._tagName = "v:polyline";
_p._value = null;
_p.setValue = function (nValue) {
    this._value = nValue;
    if (this.getCreated()) this._calculatePoints();
};
_p._calculatePoints = function () {
    var v = this._parent._valueToAngle(this._value);
    var vr = v / 180 * Math.PI;
    var r = this.getOuterRadius();
    var r2 = this.getInnerRadius();
    var p1x = r * Math.sin(vr);
    var p1y = r * Math.cos(vr);
    var p2x = r2 * Math.sin(vr);
    var p2y = r2 * Math.cos(vr);
    var a = vr - Math.PI / 2;
    var iw = this._innerWidth / 2;
    var ow = this._outerWidth / 2;
    var p3x = p2x + iw * Math.sin(a);
    var p3y = p2y + iw * Math.cos(a);
    var p4x = p1x + ow * Math.sin(a);
    var p4y = p1y + ow * Math.cos(a);
    a += Math.PI;
    p1x += ow * Math.sin(a);
    p1y += ow * Math.cos(a);
    p2x += iw * Math.sin(a);
    p2y += iw * Math.cos(a);
    var w = this._parent.getWidth() / 2;
    var h = this._parent.getHeight() / 2;
    p1x = w + p1x;
    p1y = h - p1y;
    p2x = w + p2x;
    p2y = h - p2y;
    p3x = w + p3x;
    p3y = h - p3y;
    p4x = w + p4x;
    p4y = h - p4y;
    var pointsValue = p3x + "," + p3y + " " + p4x + "," + p4y + " " + p1x + "," + p1y + " " + p2x + "," + p2y + " " + p3x + "," + p3y;
    try {
        this._element.points.value = pointsValue;
    } catch (ex) {
        this.setHtmlProperty("points", pointsValue);
    }
};
_p.layoutComponent = function () {
    if (this._value == null) {
        var p = this._parent;
        this.setValue((p.getEndValue() - p.getStartValue()) / 2 + p.getStartValue());
    } else {
        this._calculatePoints();
    }
    BiAbstractGauge2ValueMarker.prototype.layoutComponent.call(this);
};

function BiGauge2RadialArrowNeedle() {
    if (_biInPrototype) return;
    BiAbstractGauge2ValueMarker.call(this);
};
_p = _biExtend(BiGauge2RadialArrowNeedle, BiGauge2RadialNeedle, "BiGauge2RadialArrowNeedle");
_p._tagName = "v:polyline";
_p._value = null;
BiGauge2RadialArrowNeedle.addProperty("pointerLength", BiAccessType.READ_WRITE);
_p.setValue = function (nValue) {
    this._value = nValue;
    if (this._parent) this._calculatePoints();
};
_p._calculatePoints = function () {
    var l;
    if (!this._ps) {
        var wi = this._innerWidth / 2;
        var wo = this._outerWidth / 2;
        var ri = this.getInnerRadius();
        var ro = this.getOuterRadius();
        l = ro - ri;
        var pl = this._pointerLength || l / 3;
        var x = [-wo, -wi, wi, wo];
        var y = [ri, ro - pl, ro];
        this._ps = [
            [x[1], y[0]],
            [x[1], y[1]],
            [x[0], y[1]],
            [0, y[2]],
            [x[3], y[1]],
            [x[2], y[1]],
            [x[2], y[0]],
            [x[1], y[0]]
        ];
    }
    var a = this._parent._valueToAngle(this._value) / 180 * Math.PI;
    var ca = Math.cos(a);
    var sa = Math.sin(a);
    var w = this._parent.getWidth() / 2;
    var h = this._parent.getHeight() / 2;
    var ps = [];
    l = this._ps.length;
    for (var i = 0; i < l; i++) {
        ps.push(this._ps[i][0] * ca + this._ps[i][1] * sa + w);
        ps.push(this._ps[i][0] * sa - this._ps[i][1] * ca + h);
    }
    ps = ps.join(",");
    try {
        this._element.points.value = ps;
    } catch (ex) {
        this.setHtmlProperty("points", ps);
    }
};
_p.layoutComponent = function () {
    if (this._value == null) {
        var p = this._parent;
        this.setValue((p.getEndValue() - p.getStartValue()) / 2 + p.getStartValue());
    }
    this._calculatePoints();
    BiAbstractGauge2ValueMarker.prototype.layoutComponent.call(this);
};

function BiGauge2LinearNeedle() {
    if (_biInPrototype) return;
    BiAbstractGauge2ValueMarker.call(this);
};
_p = _biExtend(BiGauge2LinearNeedle, BiAbstractGauge2ValueMarker, "BiGauge2LinearNeedle");
BiGauge2LinearNeedle.addProperty("angle", BiAccessType.READ_WRITE);
BiGauge2LinearNeedle.addProperty("needlePosition", BiAccessType.READ_WRITE);
BiGauge2LinearNeedle.addProperty("needleBase", BiAccessType.READ_WRITE);
BiGauge2LinearNeedle.addProperty("needleHeight", BiAccessType.READ_WRITE);
_p._tagName = "v:polyline";
_p.setValue = function (n) {
    this._value = n;
    if (this.getCreated()) this._calculatePoints();
};
_p._calculatePoints = function () {
    var r = this._parent._valueToPosition(this._value);
    if (this._angle == null) this._angle = this._parent._angle;
    var angle = this._angle / 180 * Math.PI;
    var x = r * Math.sin(angle);
    var y = r * Math.cos(angle);
    var nh = this._needlePosition < 0 ? this._needleHeight / 2 : -this._needleHeight / 2;
    var p1x = x + (this._needlePosition + nh) * Math.cos(angle);
    var p1y = y - (this._needlePosition + nh) * Math.sin(angle);
    var tx = x + (this._needlePosition - nh) * Math.cos(angle);
    var ty = y - (this._needlePosition - nh) * Math.sin(angle);
    var p2x = tx - this._needleBase / 2 * Math.sin(angle + Math.PI);
    var p2y = ty - this._needleBase / 2 * Math.cos(angle + Math.PI);
    var p3x = tx + this._needleBase / 2 * Math.sin(angle + Math.PI);
    var p3y = ty + this._needleBase / 2 * Math.cos(angle + Math.PI);
    var cx = this._parent.getWidth() / 2;
    var cy = this._parent.getHeight() / 2;
    p1x = cx + p1x;
    p1y = cy - p1y;
    p2x = cx + p2x;
    p2y = cy - p2y;
    p3x = cx + p3x;
    p3y = cy - p3y;
    var pointsValue = p3x + "," + p3y + " " + p1x + "," + p1y + " " + p2x + "," + p2y + " " + p3x + "," + p3y;
    try {
        this._element.points.value = pointsValue;
    } catch (ex) {
        this.setHtmlProperty("points", pointsValue);
    }
};
_p.layoutComponent = function () {
    if (this._value == null) {
        var p = this._parent;
        this.setValue((p.getEndValue() - p.getStartValue()) / 2 + p.getStartValue());
    } else {
        this._calculatePoints();
    }
    BiAbstractGauge2ValueMarker.prototype.layoutComponent.call(this);
};

function BiAbstractGauge2ScaleSection() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
    this.setSectionWidth(20);
};
_p = _biExtend(BiAbstractGauge2ScaleSection, BiGauge2Component, "BiAbstractGauge2ScaleSection");
BiAbstractGauge2ScaleSection.addProperty("startValue", BiAccessType.READ_WRITE);
BiAbstractGauge2ScaleSection.addProperty("endValue", BiAccessType.READ_WRITE);
BiAbstractGauge2ScaleSection.addProperty("sectionWidth", BiAccessType.READ_WRITE);

function BiGauge2RadialScaleSection() {
    if (_biInPrototype) return;
    BiAbstractGauge2ScaleSection.call(this);
    this.setHtmlProperty("filled", true);
};
_p = _biExtend(BiGauge2RadialScaleSection, BiAbstractGauge2ScaleSection, "BiGauge2RadialScaleSection");
_p._tagName = "v:shape";
BiGauge2RadialScaleSection.addProperty("radius", BiAccessType.READ_WRITE);
BiGauge2RadialScaleSection.addProperty("color", BiAccessType.READ);
_p.setColor = function (sColor) {
    this._color = sColor;
    this.setHtmlProperty("fillcolor", sColor);
};
_p.setSectionWidth = function (nSectionWidth) {
    this._sectionWidth = nSectionWidth;
};
_p._calculateAttributes = function () {
    var r1 = this._radius + this._sectionWidth / 2;
    var r2 = this._radius - this._sectionWidth / 2;
    var w = this._parent.getWidth();
    var h = this._parent.getHeight();
    var x0 = w / 2;
    var y0 = h / 2;
    var a0 = this._parent._valueToAngle(this._startValue) / 180 * Math.PI;
    var a2 = this._parent._valueToAngle(this._endValue) / 180 * Math.PI;
    var a1 = (a0 + a2) / 2;
    var isCircle = Math.abs(a2 - a0) - 2 * Math.PI > -0.01;
    var el = this._element;
    el.style.width = w;
    el.style.height = h;
    el.coordorigin = -x0 + " " + -y0;
    el.coordsize = w + " " + h;
    r1 = Math.round(r1);
    r2 = Math.round(r2);
    var p0, p1, p2;
    if (a1 > a0) {
        p0 = Math.round(Math.sin(a2) * r1) + " " + Math.round(-Math.cos(a2) * r1);
        p1 = Math.round(Math.sin(a1) * r1) + " " + Math.round(-Math.cos(a1) * r1);
        p2 = Math.round(Math.sin(a0) * r1) + " " + Math.round(-Math.cos(a0) * r1);
    } else {
        p0 = Math.round(Math.sin(a0) * r1) + " " + Math.round(-Math.cos(a0) * r1);
        p1 = Math.round(Math.sin(a1) * r1) + " " + Math.round(-Math.cos(a1) * r1);
        p2 = Math.round(Math.sin(a2) * r1) + " " + Math.round(-Math.cos(a2) * r1);
    }
    var d;
    if (!isCircle) {
        d = ["ar", -r1, " ", -r1, " ", r1, " ", r1, " ", p0, " ", p2, "wa", -r2, " ", -r2, " ", r2, " ", r2, " ", p2, " ", p0, " x"];
    } else {
        d = ["ar", -r1, " ", -r1, " ", r1, " ", r1, " ", p0, " ", p1, "at", -r1, " ", -r1, " ", r1, " ", r1, " ", p1, " ", p2, "wr", -r2, " ", -r2, " ", r2, " ", r2, " ", p2, " ", p1, "wa", -r2, " ", -r2, " ", r2, " ", r2, " ", p1, " ", p0];
    }
    el.path = d.join("");
};
_p.layoutComponent = function () {
    this._calculateAttributes();
    BiAbstractGauge2ScaleSection.prototype.layoutComponent.call(this);
};

function BiGauge2Label() {
    if (_biInPrototype) return;
    BiGauge2Component.call(this);
    this.setAnchorHorizontal("center");
};
_p = _biExtend(BiGauge2Label, BiGauge2Component, "BiGauge2Label");
_p._tagName = "v:shape";
_p._font = BiFont.fromString("verdana 70 bold");
_p._anchorVertical = "middle";
_p._color = "black";
BiGauge2Label.addProperty("x", BiAccessType.READ_WRITE);
BiGauge2Label.addProperty("y", BiAccessType.READ_WRITE);
_p.setCenterX = _p.setX;
_p.getCenterX = _p.getX;
_p.setCenterY = _p.setY;
_p.getCenterY = _p.getY;
_p.setWidth = _p.setHeight = BiAccessType.FUNCTION_EMPTY;
BiGauge2Label.addProperty("anchorHorizontal", BiAccessType.READ);
_p.setAnchorHorizontal = function (sAnchorHorizontal) {
    this._anchorHorizontal = sAnchorHorizontal;
    this.setStyleProperty("textAlign", sAnchorHorizontal);
};
BiGauge2Label.addProperty("anchorVertical", BiAccessType.READ_WRITE);
BiGauge2Label.addProperty("font", BiAccessType.READ_WRITE);
_p.setFont = function (o) {
    if (!(o instanceof BiFont)) {
        o = BiFont.fromString("" + o);
    }
    this._font = o;
    if (o instanceof BiFont) {
        if (o.getBold()) this.setStyleProperty("fontWeight", "bold");
        else this.setStyleProperty("fontWeight", "normal");
        if (!o.getSize) o.setSize(50);
        if (!o.getName()) o.setName("verdana");
        this.setStyleProperty("fontFamily", o.getName());
    }
};
_p._create = function (oDocument) {
    BiGauge2Component.prototype._create.call(this, oDocument);
    var el = this._element;
    el.innerText = this._text;
};
_p.setText = function (sText) {
    this._text = String(sText);
    if (this._created) {
        this._element.innerText = this._text;
        this.invalidateLayout();
    }
};
_p.getText = function () {
    return this._text;
};
_p.layoutComponent = function () {
    var el = this._element;
    var sf = this._getScaleFactor() || 1;
    var s = this._font.getSize();
    var w = Math.round(this._text.length * s);
    var h = Math.round(s * 1.3);
    el.style.fontSize = Math.round(s * sf) + "px";
    el.style.width = w + "px";
    el.style.height = h + "px";
    el.style.top = Math.round(this._y - h / 2);
    switch (this._anchorHorizontal) {
        case "center":
            el.style.left = Math.round(this._x - w / 2);
            break;
        case "left":
            el.style.left = this._x;
            break;
        case "right":
            el.style.left = this._x - w;
            break;
    }
    switch (this._anchorVertical) {
        case "top":
            el.style.top = this._y;
            break;
        case "middle":
            el.style.top = Math.round(this._y - h / 2);
            break;
        case "bottom":
            el.style.top = this._y - h;
            break;
    }
};