public class GuidebookOrganization {

	public Integer id;
	public String first_name;
	public String description;
	public String avatar;

	public static GuidebookOrganization parse(String json) {
		return (GuidebookOrganization) System.JSON.deserialize(json, GuidebookOrganization.class);
	}
}