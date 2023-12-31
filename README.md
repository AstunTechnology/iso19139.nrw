# Natural Resources Wales Metadata Profile schema plugin (iso19139.nrw)

Natural Resources Wales Metadata Profile

## GeoNetwork versions to use with this plugin

**Use the correct branch for your version of GeoNetwork. The default branch is for GeoNetwork 4.2 and this is the recommended version.**

## Installing the plugin in GeoNetwork 4.2.x (recommended version)

### Adding to an existing installation

 * Download or clone this repository, ensuring you choose the correct branch. 
 * Copy `src/main/plugin/iso19139.nrw` to `INSTALL_DIR/geonetwork/WEB_INF/data/config/schema_plugins/iso19139.nrw` in your installation.
 * Copy `target/schema-iso19139.nrw-3.12-SNAPSHOT.jar` to `INSTALL_DIR/geonetwork/WEB_INF/lib`
 * Restart GeoNetwork
 * Check that the schema is registered by visiting Admin Console -> Metadata and Templates -> Standards in GeoNetwork. If you do not see iso19139.nrw then it is not correctly deployed. Check your GeoNetwork log files for errors.

### Adding the plugin to the source code prior to compiling GeoNetwork

The best approach is to add the plugin as a submodule. Use https://github.com/geonetwork/core-geonetwork/blob/4.2.x/add-schema.sh for automatic deployment:

```
.\add-schema.sh iso19139.nrw http://github.com/astuntechnology/iso19139.nrw 4.2.x
```

#### Building the application 

See https://geonetwork-opensource.org/manuals/trunk/en/maintainer-guide/installing/installing-from-source-code.html. 

Ensure that you build GeoNetwork with the directive `-DschemasCopy=True` (and also use the same directive if running using the embedded jetty server plugin). For example from the GeoNetwork root directory:

```
sudo mvn clean install -DskipTests -DschemasCopy=true -Pes
cd web
sudo mvn jetty:run -DschemasCopy=true
```


Once the application is built `web/target/geonetwork.war` will contain GeoNetwork with the NRW schema plugin included.