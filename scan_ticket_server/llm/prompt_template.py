from typing import Dict, Any, List
from dataclasses import dataclass
import json
import os

@dataclass
class PromptTemplate:
    """Template for model prompts"""
    name: str
    template: str
    description: str
    required_variables: List[str]
    model_specific_configs: Dict[str, Dict[str, Any]]

class PromptManager:
    """Manage prompt templates for different models and use cases"""
    
    def __init__(self, templates_dir: str = None):
        self.templates: Dict[str, PromptTemplate] = {}
        self.templates_dir = templates_dir or "prompts"
        self._load_templates()
    
    def _load_templates(self):
        """Load templates from the templates directory"""
        if not os.path.exists(self.templates_dir):
            os.makedirs(self.templates_dir)
            return
        
        for filename in os.listdir(self.templates_dir):
            if filename.endswith('.json'):
                with open(os.path.join(self.templates_dir, filename), 'r', encoding='utf-8') as f:
                    template_data = json.load(f)
                    template = PromptTemplate(
                        name=template_data['name'],
                        template=template_data['template'],
                        description=template_data['description'],
                        required_variables=template_data['required_variables'],
                        model_specific_configs=template_data.get('model_specific_configs', {})
                    )
                    self.templates[template.name] = template
    
    def get_template(self, name: str) -> PromptTemplate:
        """Get a prompt template by name"""
        if name not in self.templates:
            raise KeyError(f"Template '{name}' not found")
        return self.templates[name]
    
    def render_prompt(self, template_name: str, variables: Dict[str, Any]) -> str:
        """Render a prompt template with variables"""
        template = self.get_template(template_name)
        
        # Validate required variables
        missing_vars = [var for var in template.required_variables if var not in variables]
        if missing_vars:
            raise ValueError(f"Missing required variables: {', '.join(missing_vars)}")
        
        # Render template
        rendered = template.template
        for key, value in variables.items():
            rendered = rendered.replace(f"{{{key}}}", str(value))
        
        return rendered
    
    def add_template(self, template: PromptTemplate):
        """Add a new prompt template"""
        self.templates[template.name] = template
        self._save_template(template)
    
    def _save_template(self, template: PromptTemplate):
        """Save template to file"""
        if not os.path.exists(self.templates_dir):
            os.makedirs(self.templates_dir)
            
        template_data = {
            'name': template.name,
            'template': template.template,
            'description': template.description,
            'required_variables': template.required_variables,
            'model_specific_configs': template.model_specific_configs
        }
        
        filename = f"{template.name.lower().replace(' ', '_')}.json"
        filepath = os.path.join(self.templates_dir, filename)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(template_data, f, indent=2, ensure_ascii=False)
