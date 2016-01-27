/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.electrotank.electroserver5.examples.digging;

import com.electrotank.electroserver5.extensions.BasePlugin;
import com.electrotank.electroserver5.extensions.ChainAction;
import com.electrotank.electroserver5.extensions.api.ScheduledCallback;
import com.electrotank.electroserver5.extensions.api.value.EsObject;
import com.electrotank.electroserver5.extensions.api.value.EsObjectRO;
import com.electrotank.electroserver5.extensions.api.value.UserEnterContext;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.AbstractMap;
import java.util.AbstractQueue;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.logging.Level;
import org.slf4j.Logger;
import nu.xom.Builder;
import nu.xom.Document;
import nu.xom.Element;
import nu.xom.Elements;
import nu.xom.ParsingException;
import nu.xom.ValidityException;
/**
 *
 * @author bobolicious3000
 */
public class XmlManager {
    
    
    Builder builder;
    Document doc;
    Logger _logger;
    ArrayList<QuestionObj> questionList;
    
    public XmlManager(Logger logger) 
    {  
        _logger = logger;
          _logger.debug("tank killed!");
    }
    
    public void createQuestions(String path)
    {
        
        questionList = new ArrayList();
        
           builder = new Builder();
           doc = null;
   try {
            doc = builder.build(path);
        } catch (ParsingException ex) {
            java.util.logging.Logger.getLogger(DiggingGamePlugin.class.getName()).log(Level.SEVERE, null, ex);
        }  catch (IOException ex) {
            java.util.logging.Logger.getLogger(DiggingGamePlugin.class.getName()).log(Level.SEVERE, null, ex);
        }
           
          if (doc != null)
                  {
                         Element root = doc.getRootElement();
                      //     getApi().getLogger().debug("Settings document read! " + root.getQualifiedName() + " !!.");
           
                         Element category = root.getFirstChildElement("Category");
                         
                          _logger.debug("The category is " + category.getValue());
                         
                           Element questionNode = root.getFirstChildElement("TheQuestions");
                         Elements children = questionNode.getChildElements();  
                      for (int i = 0; i < children.size(); i++)
                      {
                        //  Node node = root.getChild(i);
                         
                          QuestionObj tempQuestion = new QuestionObj();
                          
                         String yo = children.get(i).getValue();
                         
                         Element qText = children.get(i).getFirstChildElement("qText");
                         Element aAns = children.get(i).getFirstChildElement("aAns");
                         Element bAns = children.get(i).getFirstChildElement("bAns");
                         Element cAns = children.get(i).getFirstChildElement("cAns");
                         Element dAns = children.get(i).getFirstChildElement("dAns");
                         Element correctAns = children.get(i).getFirstChildElement("correctAns");
                         
                          _logger.debug("Question " + i + " is " + qText.getValue() + " !!.");
                          
                          tempQuestion.questionText = qText.getValue();
                          tempQuestion.aAns = aAns.getValue();
                          tempQuestion.bAns = bAns.getValue();
                          tempQuestion.cAns = cAns.getValue();
                          tempQuestion.dAns = dAns.getValue();
                          tempQuestion.correctAns = correctAns.getValue();
                          
                          questionList.add(tempQuestion);
                          _logger.debug("size of question array now is: " + questionList.size());
                          
                      }
       //    Element simple = root.getFirstChildElement("fibonacci");
           
       //    getApi().getLogger().debug("Settings document read! " + simple.getValue()+ " !!.");
                  }
        
        
    }
    
    
    
    public QuestionObj pullRandomNewQuestion()
    {
        int sizeOfList = questionList.size();
        
        Random rnd = new Random();
        int randomNum = rnd.nextInt(sizeOfList);
        
        QuestionObj pulledQuestionObj = questionList.get(randomNum);
        
        questionList.remove(randomNum);
                
        return pulledQuestionObj;
    }
    
    
    
    
    
}
