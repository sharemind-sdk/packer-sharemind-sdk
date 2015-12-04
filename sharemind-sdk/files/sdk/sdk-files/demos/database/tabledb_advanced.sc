import shared3p;
import shared3p_table_database;
import stdlib;
import table_database;

domain pd_shared3p shared3p;

void main() {
    string ds = "DS1"; // Data source name
    string tbl = "table"; // Table name

    // Open database before running operations on it
    tdbOpenConnection(ds);


    // Check if a table exists
    if (tdbTableExists(ds, tbl)) {
        // Delete existing table
        print("Deleting existing table: ", tbl);
        tdbTableDelete(ds, tbl);
    }


    // Create a new table with heterogeneous data
    print("Creating new table: ", tbl);

    /*
     * We want to create a simple table with three columns:
     *
     *       -----------------------------------------------------------
     * Name: |       "index" |      "measurement" | "have_measurement" |
     * Type: | public uint64 | pd_shared3p uint64 |   pd_shared3p bool |
     *       -----------------------------------------------------------
     *       |             0 |                  0 |               true |
     *       |             1 |                 10 |               true |
     *       |             2 |                 20 |               true |
     *       |             3 |                 30 |               true |
     *       |             4 |                 40 |               true |
     *       -----------------------------------------------------------
     */

    // Create a new "vector map/value map" for storing arguments to the table
    // creation call.
    uint params = tdbVmapNew();

    // Column 0, name "index", type public uint64
    {
        uint64 vtype;
        tdbVmapAddType(params, "types", vtype);
        tdbVmapAddString(params, "names", "index");
    }

    // Column 1, name "measurement", type pd_shared3p uint64
    {
        pd_shared3p uint64 vtype;
        tdbVmapAddType(params, "types", vtype);
        tdbVmapAddString(params, "names", "measurement");
    }

    // Column 2, name "have_measurement", type pd_shared3p bool
    {
        pd_shared3p bool vtype;
        tdbVmapAddType(params, "types", vtype);
        tdbVmapAddString(params, "names", "have_measurement");
    }

    // Create the table
    tdbTableCreate(ds, tbl, params);

    // Free the parameter map
    tdbVmapDelete(params);


    // Insert some data
    uint nrows = 5;
    params = tdbVmapNew();

    for (uint i = 0; i < nrows; ++i) {
        uint64 index = i;
        pd_shared3p uint64 measurement = i * 10;
        pd_shared3p bool have_measurement = true;

        tdbVmapAddValue(params, "values", index);
        tdbVmapAddValue(params, "values", measurement);
        tdbVmapAddValue(params, "values", have_measurement);

        tdbInsertRow(ds, tbl, params);
        print("Inserting row [", i, "]: {", index, ", ", declassify(measurement), ", ", declassify(have_measurement), "}");

        // Clear the parameters for this row
        tdbVmapClear(params);
    }

    // Multiple rows can also be added with a single insert
    /*
    for (uint i = 0; i < nrows; ++i) {
        uint64 index = i;
        pd_shared3p uint64 measurement = i * 10;
        pd_shared3p bool have_measurement = true;

        if (i != 0) {
            // This has to be called in-between rows
            tdbVmapAddBatch(params);
        }

        tdbVmapAddValue(params, "values", index);
        tdbVmapAddValue(params, "values", measurement);
        tdbVmapAddValue(params, "values", have_measurement);

        print("Inserting row [", i, "]: {", index, ", ", declassify(measurement), ", ", declassify(have_measurement), "}");
    }

    tdbInsertRow(ds, tbl, params);
    */

    tdbVmapDelete(params);

    // Read table info
    print("Table name: ", tbl);
    print("Columns: ", tdbGetColumnCount(ds, tbl));
    print("Rows: ", tdbGetRowCount(ds, tbl));

    {
        uint names = tdbGetColumnNames(ds, tbl);
        uint nnames = tdbVmapStringVectorSize(names, "names");

        for (uint i = 0; i < nnames; ++i) {
            string name = tdbVmapGetString(names, "names", i);
            print("Column [", i, "] name: \"", name, "\"");
        }
    }

    // Read the data back as columns
    {
        /*
         * We don't have to use the vmap API because columns have values of a
         * single type.
         */

        uint64 [[1]] index = tdbReadColumn(ds, tbl, "index");
        pd_shared3p uint64 [[1]] measurement = tdbReadColumn(ds, tbl, "measurement");
        pd_shared3p bool [[1]] have_measurement = tdbReadColumn(ds, tbl, "have_measurement");
        print("Reading column [index]: ", _vectorToString(index));
        print("Reading column [measurement]: ", _vectorToString(declassify(measurement)));
        print("Reading column [have_measurement]: ", _vectorToString(declassify(have_measurement)));
    }

    // Close the database. All databases will also be closed automatically on
    // exit.
    tdbCloseConnection(ds);
}
