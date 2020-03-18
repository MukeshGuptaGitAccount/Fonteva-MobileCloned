public class GuidebookProvisionProduct {

	public Decimal owner;
	public Integer guide_quantity;

	public static GuidebookProvisionProduct parse(String json) {
		return (GuidebookProvisionProduct) System.JSON.deserialize(json, GuidebookProvisionProduct.class);
	}
}