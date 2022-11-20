import metadataExemple from "./metadata.exemple.json";
import GeneratorService from "@services/generator.service";

const generatorService = new GeneratorService();

describe("Test generator token", () => {
  it("generate value", async () => {
    for (let index = 0; index < 100; index++) {
      const attributes = await generatorService.randomValue(
        metadataExemple.attributes.head,
      );
    }
  });

  it("generate attribute", async () => {
    const attributes = await generatorService.generateAttribute(
      metadataExemple.attributes,
    );
  });

  it("generate metadata", async () => {
    const attributes = await generatorService.generateMetadata(metadataExemple);
  });

  it("generate tokens", async () => {
    const quantity = 100;
    const tokens = await generatorService.generateTokens(quantity, metadataExemple);
    expect(tokens.length).toEqual(quantity);
    for (let index = 0; index < quantity; index++) {
      expect(tokens[index].name).toEqual(metadataExemple.name);
      expect(tokens[index].description).toEqual(metadataExemple.description);
      expect(tokens[index].name).toEqual(metadataExemple.name);
      Object.keys(tokens[index].attributes).forEach(trait => {
        expect(Object.keys(metadataExemple.attributes).includes(trait)).toBe(true);
      });
      expect(Object.keys(tokens[index].attributes).length).toEqual(
        Object.keys(metadataExemple.attributes).length,
      );
    }
  });

  it("generate tokens And write them", async () => {
    const quantity = 100;
    const tokens = await generatorService.generateTokens(quantity, metadataExemple);

    await generatorService.writeJson(tokens);

    const zip = await generatorService.updateZipArchive("./files/test.zip", quantity);
    console.log(zip);
  });
});
