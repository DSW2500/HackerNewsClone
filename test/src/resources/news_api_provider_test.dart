import "package:news/src/resources/news_api_provider.dart";
import "dart:convert";
import "package:test/test.dart";
import "package:http/testing.dart";
import "package:http/http.dart";

void main() {
  //Testing : FetTopIds
  test("FetchTopIds returns a list of ids", () async {
//setup of testcase:
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    final ids = await newsApi.fetchTopIds();
    expect(ids, [1, 2, 3, 4]);
  });

  test("FetchItem returns an ItemModel", () async {
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async {
      final jsonMap = {"id": 1};
      return Response(json.encode(jsonMap), 200);
    });
    final item = await newsApi.fetchItem(99);
    expect(item.id, 1);
  });
}
