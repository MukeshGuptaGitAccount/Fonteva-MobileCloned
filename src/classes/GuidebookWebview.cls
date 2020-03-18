public class GuidebookWebview {
	public String name;
	public Integer id;
	public String webview_type;
	public decimal guide;
	public String url;
	public Object html_file;

	
	public static GuidebookWebview parse(String json) {
		return (GuidebookWebview) System.JSON.deserialize(json, GuidebookWebview.class);
	}
}