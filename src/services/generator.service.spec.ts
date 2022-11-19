import metadatas from "./metadata.json";
import GeneratorService from "@services/generator.service";

const generatorService = new GeneratorService();

describe("Test generator token", () => {
  it("generate value", async () => {
    for (let index = 0; index < 100; index++) {
      const attributes = await generatorService.randomValue(metadatas.attributes.head);
    }
  });

  it("generate attribute", async () => {
    const attributes = await generatorService.generateAttribute(metadatas.attributes);
  });

  it("generate metadata", async () => {
    const attributes = await generatorService.generateMetadata(metadatas);
  });

  it("generate tokens", async () => {
    const quantity = 100;
    const tokens = await generatorService.generateTokens(quantity, metadatas);
    expect(tokens.length).toEqual(quantity);
    for (let index = 0; index < quantity; index++) {
      expect(tokens[index].name).toEqual(metadatas.name);
      expect(tokens[index].description).toEqual(metadatas.description);
      expect(tokens[index].name).toEqual(metadatas.name);
      Object.keys(tokens[index].attributes).forEach(trait => {
        expect(Object.keys(metadatas.attributes).includes(trait)).toBe(true);
      });
      expect(Object.keys(tokens[index].attributes).length).toEqual(
        Object.keys(metadatas.attributes).length,
      );
    }
  });
});
