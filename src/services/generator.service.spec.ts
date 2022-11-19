import metadatas from './metadata.json';
import GeneratorService from '@services/generator.service';

const generatorService = new GeneratorService();

describe('Test generator token', () => {
  it('generate attribute', async () => {
    for (let index = 0; index < 100; index++) {
      const attributes = await generatorService.randomValue(metadatas.attributes.head);
    }
  });
  it('generate attribute', async () => {
    const attributes = await generatorService.generateAttribute(metadatas.attributes);
    console.log(attributes);
  });
});
