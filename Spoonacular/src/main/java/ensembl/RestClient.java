import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Scanner;

public class RestClient {

    private final String server;
    private final int requestPerSecond;
    private int requestCount = 0;
    private long limitStartTime = System.currentTimeMillis();

    public RestClient(String server, int requestPerSecond) {
        this.server = server;
        this.requestPerSecond = requestPerSecond;
    }

    public static void main(String[] args) throws InterruptedException, UnirestException {
        String q = input();
        String number = inputdigit();
        if (args.length == 1) {
            q = args[0];
        } else if (args.length == 2) {
            q = args[0];
            number = args[1];
        }
        RestClient client = new RestClient("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete", 5);
        client.printVariants(q, number);
    }

    public static String input(){
        Scanner keyboard = new Scanner(System.in);
        System.out.println("enter a search query");
        String myLine = keyboard.nextLine();
        return myLine;
    }
    public static String inputdigit() {
        Scanner keyboard = new Scanner(System.in);
        System.out.println("enter number of results");
        String mynumb = keyboard.nextLine();
        return mynumb;
    }
    public void printVariants(String q, String number) throws UnirestException, InterruptedException {
        JSONArray variants = fetchJson(String.format("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/food/ingredients/autocomplete?number=%s&query=%s",number, q)).getArray();
        System.out.println("Results");
        for (int i = 0; i < variants.length(); i++) {
            JSONObject variant = variants.getJSONObject(i);
            String srName = variant.getString("name");
            String output = String.format("%d: %s",i+1, srName);
            System.out.println(output);
        }

    }

    private JsonNode fetchJson(String url) throws UnirestException, InterruptedException {
        rateLimit();
        HttpResponse<JsonNode> response = Unirest.get(url)
                .header("X-Mashape-Key", "ZiEFxYet6PmshsmMu1nUODGtkPZbp1DXVpnjsnOgrkqXFajpD3")
                .header("Accept", "application/json")
                .asJson();
        String retryHeader = response.getHeaders().getFirst("Retry-After");

        if (response.getStatus() == 200) {
            return response.getBody();
        } else if (response.getStatus() == 429 && retryHeader != null) {
            Long waitSeconds = Long.valueOf(retryHeader);
            Thread.sleep(waitSeconds * 1000);
            return fetchJson(url);
        } else {
            throw new IllegalArgumentException("No data at " + url);
        }
    }

    private void rateLimit() throws InterruptedException {
        requestCount++;
        if (requestCount == requestPerSecond) {
            long currentTime = System.currentTimeMillis();
            long diff = currentTime - limitStartTime;
            //if less than a second has passed then sleep for the remainder of the second
            if (diff < 1000) {
                Thread.sleep(1000 - diff);
            }
            //reset
            limitStartTime = System.currentTimeMillis();
            requestCount = 0;
        }
    }
}