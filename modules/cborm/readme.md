[![Build Status](https://travis-ci.org/coldbox-modules/cbox-cborm.svg?branch=development)](https://travis-ci.org/coldbox-modules/cbox-cborm)

# Welcome To The ColdBox ORM Module

This module provides you with several enhancements when interacting with the ColdFusion ORM via Hibernate.  It provides you with virtual service layers,
active record patterns, criteria and detached criteria queries, entity compositions, populations and so much more to make your ORM life easier!  In other words, it makes using ORM not SUCK! :rocket:

## LICENSE

Apache License, Version 2.0.

## IMPORTANT LINKS

**Source & Changelog**
- https://github.com/coldbox-modules/cbox-cborm
- [Changelog](changelog.md)

**Documentation**
- https://coldbox-orm.ortusbooks.com/

## SYSTEM REQUIREMENTS

- Lucee 4.5+
- ColdFusion 11+

# INSTRUCTIONS

Use CommandBox cli to install:

```bash
box install cborm
```

Unfortunately, due to the way that ORM is loaded by ColdFusion, if you are using the ORM EventHandler or ActiveEntity or any ColdBox Proxies that require ORM, you must create an Application Mapping in the `Application.cfc` like this:

```js
this.mappings[ "/cborm" ] = COLDBOX_APP_ROOT_PATH & "modules/cborm";
```

This is due to the fact that the ORM event listener starts before ColdBox, so no dynamic mappings exist yet.  **Important**: Make sure you ALWAYS lazy load dependencies in your event handlers to avoid chicken and the egg issues.

## WireBox DSL

The module also registers a new WireBox DSL called `entityservice` which can produce virtual or base ORM entity services:

- `entityservice` -  Inject a global ORM service so you can work with ANY entity
- `entityservice:{entityName}` - Inject a Virtual entity service according to `entityName`

## Settings

Here are the module settings you can place in your `ColdBox.cfc` under an `orm` structure:

```js
orm = {
    injection = {
        enabled = true, include = "", exclude = ""
    }
}
```

## Validation

We have also migrated the `UniqueValidator` from the **validation** module into our
ORM module.  It is mapped into wirebox as `UniqueValidator@cborm` so you can use in your constraints like so:

```js
{ fieldName : { validator: "UniqueValidator@cborm" } }


********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************

#### HONOR GOES TO GOD ABOVE ALL
Because of His grace, this project exists. If you don't like this, then don't read it, its not for you.

> "Therefore being justified by faith, we have peace with God through our Lord Jesus Christ:
By whom also we have access by faith into this grace wherein we stand, and rejoice in hope of the glory of God.
And not only so, but we glory in tribulations also: knowing that tribulation worketh patience;
And patience, experience; and experience, hope:
And hope maketh not ashamed; because the love of God is shed abroad in our hearts by the 
Holy Ghost which is given unto us. ." Romans 5:5

### THE DAILY BREAD

 > "I am the way, and the truth, and the life; no one comes to the Father, but by me (JESUS)" Jn 14:1-12