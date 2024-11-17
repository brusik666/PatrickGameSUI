//
//  TextureProvider.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/9/24.
//
import SpriteKit

class TextureProvider {
    
    static let shared = TextureProvider()

    private var textureCache: [String: SKTexture] = [:]
    // Private initializer to prevent external instantiation
    private init() {}
    
    // Method to get a texture by name
    func getTexture(named name: String) -> SKTexture {
        // Check if the texture is already in the cache
        if let cachedTexture = textureCache[name] {
            return cachedTexture
        }
        
        // If not, load the texture, cache it, and return it
        let texture = SKTexture(imageNamed: name)
        textureCache[name] = texture
        return texture
    }
    
    func getAtlas(named name: String) -> SKTextureAtlas {
        let atlas = SKTextureAtlas(named: name)
        return atlas
    }
    
    // Method to preload textures
    func preloadTextures(names: [String], completion: @escaping () -> Void) {
        // Create an array to hold textures to preload
        var textures: [SKTexture] = []
        
        for name in names {
            if let cachedTexture = textureCache[name] {
                textures.append(cachedTexture)
            } else {
                let texture = SKTexture(imageNamed: name)
                textureCache[name] = texture
                textures.append(texture)
            }
        }
        
        // Preload textures asynchronously
        SKTexture.preload(textures, withCompletionHandler: completion)
    }
    
    // Method to clear the texture cache
    func clearCache() {
        textureCache.removeAll()
    }
}
