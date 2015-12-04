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

    // Create a new table with homogeneous data
    print("Creating new table: ", tbl);
    uint ncols = 10;
    pd_shared3p uint vtype;
    tdbTableCreate(ds, tbl, vtype, ncols);

    // Insert data rows
    uint nrows = 5;
    pd_shared3p uint [[1]] row(ncols);
    for (uint i = 0; i < nrows; ++i) {
        row = i;
        tdbInsertRow(ds, tbl, row);
        print("Inserting row [", i, "]: ", _vectorToString(declassify(row)));
    }

    // Read table info
    print("Table name: ", tbl);
    print("Columns: ", tdbGetColumnCount(ds, tbl));
    print("Rows: ", tdbGetRowCount(ds, tbl));

    // Read the data back as columns
    for (uint i = 0; i < ncols; ++i) {
        pd_shared3p uint [[1]] col = tdbReadColumn(ds, tbl, i);
        print("Reading column [", i, "]: ", _vectorToString(declassify(col)));
    }

    // Close the database. All databases will also be closed automatically on
    // exit.
    tdbCloseConnection(ds);
}
