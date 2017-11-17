package expire.testapp;

import android.app.FragmentManager;
import android.content.ContentValues;
import android.content.DialogInterface;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.app.DialogFragment;

import expire.testapp.db.FoodItemContract;
import expire.testapp.db.FoodItemDbHelper;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    private FoodItemDbHelper mHelper;
    private ListView mFoodItemListView;
    private ArrayAdapter<String> mAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mHelper = new FoodItemDbHelper(this);
        mFoodItemListView = (ListView) findViewById(R.id.list_todo);

        updateUI();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_add_item:
                final EditText itemEditText = new EditText(this);
                final EditText itemTypeEditText = new EditText(this);
                FragmentManager frmng = getFragmentManager();
                DialogFragment dia = new AddItemDialogFragment();
                dia.show(frmng, null);
//                AlertDialog dialog = new AlertDialog.Builder(this)
//                        .setTitle("Add A New Food  ")
//                        .setMessage("Food:")
//                        .setView(itemEditText)
//                        .setMessage("Food Type:")
//                        .setView(itemTypeEditText)
//                        .setPositiveButton("Add", new DialogInterface.OnClickListener() {
//                            @Override
//                            public void onClick(DialogInterface dialog, int which) {
//                                String foodItem = String.valueOf(itemEditText.getText());
//                                SQLiteDatabase db = mHelper.getWritableDatabase();
//                                ContentValues values = new ContentValues();
//                                values.put(FoodItemContract.FoodItemEntry.COL_FOOD_TITLE, foodItem);
//                                db.insertWithOnConflict(FoodItemContract.FoodItemEntry.TABLE,
//                                        null,
//                                        values,
//                                        SQLiteDatabase.CONFLICT_REPLACE);
//                                db.close();
//                                updateUI();
//                            }
//                        })
//                        .setNegativeButton("Cancel", null)
//                        .create();
//                dialog.show();
                return true;

            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void deleteTask(View view) {
        View parent = (View) view.getParent();
        TextView taskTextView = (TextView) parent.findViewById(R.id.item_title);
        String task = String.valueOf(taskTextView.getText());
        SQLiteDatabase db = mHelper.getWritableDatabase();
        db.delete(FoodItemContract.FoodItemEntry.TABLE,
                FoodItemContract.FoodItemEntry.COL_FOOD_TITLE + " = ?",
                new String[]{task});
        db.close();
        updateUI();
    }

    private void updateUI() {
        ArrayList<String> taskList = new ArrayList<>();
        SQLiteDatabase db = mHelper.getReadableDatabase();

        Cursor cursor = db.query(FoodItemContract.FoodItemEntry.TABLE,
                new String[]{FoodItemContract.FoodItemEntry._ID, FoodItemContract.FoodItemEntry.COL_FOOD_TITLE,
                        FoodItemContract.FoodItemEntry.COL_FOOD_TYPE, FoodItemContract.FoodItemEntry.COL_QUANTITY,
                        FoodItemContract.FoodItemEntry.COL_EXPIRE_DATE, FoodItemContract.FoodItemEntry.COL_EXPIRED},
                null, null, null, null, null);
        while (cursor.moveToNext()) {
            int idx = cursor.getColumnIndex(FoodItemContract.FoodItemEntry.COL_FOOD_TITLE);
            taskList.add(cursor.getString(idx));
        }

        if (mAdapter == null) {
            mAdapter = new ArrayAdapter<>(this,
                    R.layout.item_todo,
                    R.id.item_title,
                    taskList);
            mFoodItemListView.setAdapter(mAdapter);
        } else {
            mAdapter.clear();
            mAdapter.addAll(taskList);
            mAdapter.notifyDataSetChanged();
        }

        cursor.close();
        db.close();
    }
}
